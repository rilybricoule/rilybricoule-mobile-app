import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/update_profile_request.dart';
import '../../domain/entities/user_profile.dart';
import '../../models/user_role.dart';
import 'profile_datasource.dart';

/// Implémentation Firebase du ProfileDataSource (SANS Firebase Storage)
/// 
/// Gère les opérations de profil via:
/// - Firestore: stockage des données utilisateur
/// - Stockage local: avatars stockés localement sur l'appareil
/// - Base64: pour les petites images (fallback)
/// 
/// NOTE: Firebase Storage désactivé - utiliser backend API quand prêt
/// pour stockage cloud des avatars (voir AppConfig.USE_BACKEND_PROFILE)
class FirebaseProfileDataSource implements ProfileDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseProfileDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  @override
  Future<UserProfile> getMe() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw AuthException('Utilisateur non authentifié');
      }

      debugPrint('FirebaseProfileDataSource: getMe for user $userId');

      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        debugPrint('FirebaseProfileDataSource: User doc not found, creating default');
        final firebaseUser = _firebaseAuth.currentUser!;
        final defaultProfile = _createDefaultProfile(firebaseUser);
        await _saveUserProfile(userId, defaultProfile);
        return defaultProfile;
      }

      return _mapDocToUserProfile(doc);
    } on FirebaseException catch (e) {
      debugPrint('FirebaseProfileDataSource: Firestore error - ${e.message}');
      throw FirestoreException('Erreur chargement profil: ${e.message}', e.code);
    } catch (e) {
      debugPrint('FirebaseProfileDataSource: Error - $e');
      throw AppException('Erreur chargement profil: $e');
    }
  }

  @override
  Future<UserProfile> updateMe(UpdateProfileRequest request) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw AuthException('Utilisateur non authentifié');
      }

      debugPrint('FirebaseProfileDataSource: updateMe for user $userId');

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (request.fullName != null) {
        updates['fullName'] = request.fullName;
        await _firebaseAuth.currentUser?.updateDisplayName(request.fullName);
      }

      if (request.phone != null) {
        updates['phone'] = request.phone;
      }

      if (request.locale != null) {
        updates['locale'] = request.locale;
      }

      if (request.address != null) {
        updates['clientProfile.address'] = request.address!.toMap();
      }

      await _firestore.collection('users').doc(userId).update(updates);

      debugPrint('FirebaseProfileDataSource: Profile updated successfully');

      return getMe();
    } on FirebaseException catch (e) {
      debugPrint('FirebaseProfileDataSource: Update error - ${e.message}');
      throw FirestoreException('Erreur mise à jour profil: ${e.message}', e.code);
    } catch (e) {
      debugPrint('FirebaseProfileDataSource: Update error - $e');
      throw AppException('Erreur mise à jour profil: $e');
    }
  }

  @override
  Future<String> uploadAvatar(File image) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw AuthException('Utilisateur non authentifié');
      }

      if (!await image.exists()) {
        throw AppException('Le fichier image n\'existe pas');
      }

      // Vérifier taille (max 1MB pour stockage local/base64)
      final fileSize = await image.length();
      if (fileSize > 1 * 1024 * 1024) {
        throw AppException('Image trop grande (max 1MB). Veuillez choisir une image plus petite.');
      }

      debugPrint('FirebaseProfileDataSource: uploadAvatar (local) for user $userId');
      debugPrint('FirebaseProfileDataSource: file size = $fileSize bytes');

      // Solution 1: Stocker en base64 dans Firestore (pour petites images)
      if (fileSize < 500 * 1024) {
        // Moins de 500KB
        try {
          final bytes = await image.readAsBytes();
          final base64String = base64Encode(bytes);

          // Sauvegarder dans Firestore (limité à 1MB par document)
          await _firestore.collection('users').doc(userId).update({
            'photoUrl': 'data:image/jpeg;base64,$base64String',
            'updatedAt': FieldValue.serverTimestamp(),
          });

          await _firebaseAuth.currentUser?.updatePhotoURL('data:image/jpeg;base64,$base64String');

          debugPrint('FirebaseProfileDataSource: Avatar stored as base64 in Firestore');
          return 'data:image/jpeg;base64,$base64String';
        } catch (e) {
          debugPrint('FirebaseProfileDataSource: Base64 storage failed, trying local file...');
        }
      }

      // Solution 2: Stocker localement sur l'appareil
      final appDir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${appDir.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      final localPath = '${avatarDir.path}/$userId.jpg';
      await image.copy(localPath);

      // Sauvegarder le chemin local dans Firestore
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': 'file://$localPath',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Sauvegarder aussi dans SharedPreferences pour accès rapide
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path_$userId', localPath);

      debugPrint('FirebaseProfileDataSource: Avatar stored locally at $localPath');

      return 'file://$localPath';
    } catch (e) {
      debugPrint('FirebaseProfileDataSource: Upload error - $e');
      throw AppException('Erreur upload avatar: $e');
    }
  }

  @override
  Future<void> deleteAvatar() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw AuthException('Utilisateur non authentifié');
      }

      debugPrint('FirebaseProfileDataSource: deleteAvatar for user $userId');

      // Supprimer le fichier local si existe
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString('avatar_path_$userId');
      if (localPath != null) {
        final file = File(localPath);
        if (await file.exists()) {
          await file.delete();
        }
        await prefs.remove('avatar_path_$userId');
      }

      // Mettre à jour Firestore (retirer l'URL)
      await _firestore.collection('users').doc(userId).update({
        'photoUrl': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await _firebaseAuth.currentUser?.updatePhotoURL(null);

      debugPrint('FirebaseProfileDataSource: Avatar deleted successfully');
    } catch (e) {
      debugPrint('FirebaseProfileDataSource: Delete error - $e');
      // Ne pas throw d'erreur si suppression échoue
    }
  }

  /// Récupérer le fichier avatar local
  Future<File?> getLocalAvatarFile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final localPath = prefs.getString('avatar_path_$userId');
    if (localPath != null) {
      final file = File(localPath);
      if (await file.exists()) {
        return file;
      }
    }
    return null;
  }

  UserProfile _mapDocToUserProfile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final firebaseUser = _firebaseAuth.currentUser!;

    UserProfileAddress? address;
    if (data['clientProfile'] != null && data['clientProfile']['address'] != null) {
      address = UserProfileAddress.fromMap(data['clientProfile']['address']);
    }

    final roleStr = data['role'] as String? ?? 'client';
    final role = roleStr == 'prestataire' ? UserRole.prestataire : UserRole.client;

    return UserProfile(
      id: doc.id,
      firebaseUid: doc.id,
      role: role,
      fullName: data['fullName'] ?? firebaseUser.displayName ?? 'Utilisateur',
      email: data['email'] ?? firebaseUser.email ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      locale: data['locale'] ?? 'fr',
      address: address,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserProfile _createDefaultProfile(firebase_auth.User firebaseUser) {
    return UserProfile(
      id: firebaseUser.uid,
      firebaseUid: firebaseUser.uid,
      role: UserRole.client,
      fullName: firebaseUser.displayName ?? 'Utilisateur',
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      locale: 'fr',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _saveUserProfile(String userId, UserProfile profile) async {
    await _firestore.collection('users').doc(userId).set({
      'fullName': profile.fullName,
      'email': profile.email,
      'phone': profile.phone,
      'photoUrl': profile.photoUrl,
      'role': profile.role.name,
      'locale': profile.locale,
      'createdAt': Timestamp.fromDate(profile.createdAt),
      'updatedAt': Timestamp.fromDate(profile.updatedAt),
      'isVerified': false,
      'fcmTokens': {},
    });
  }
}
