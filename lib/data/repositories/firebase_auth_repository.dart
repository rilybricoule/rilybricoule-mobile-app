import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/app_user.dart';
import '../../models/user_role.dart';
import '../../core/errors/exceptions.dart';

/// Implémentation Firebase du AuthRepository
/// TODO: Remplacer par ApiAuthRepository quand backend disponible
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  AppUser? _currentUser;

  FirebaseAuthRepository(this._dataSource) {
    _dataSource.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        _currentUser = await _dataSource.getUserProfile(firebaseUser.uid);
      } else {
        _currentUser = null;
      }
    });
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _dataSource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _dataSource.getUserProfile(firebaseUser.uid);
    });
  }

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser> signInWithGoogle(UserRole role) async {
    try {
      debugPrint('FirebaseAuthRepository: Starting Google Sign In...');
      final credential = await _dataSource.signInWithGoogle();
      debugPrint('FirebaseAuthRepository: Got credential, user: ${credential.user?.uid}');
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Échec de la connexion Google - firebaseUser is null');
      }

      debugPrint('FirebaseAuthRepository: Checking for existing user profile...');
      AppUser? existingUser = await _dataSource.getUserProfile(firebaseUser.uid);
      debugPrint('FirebaseAuthRepository: Existing user: $existingUser');

      if (existingUser != null) {
        _currentUser = existingUser;
        return existingUser;
      }

      debugPrint('FirebaseAuthRepository: Creating new user profile...');
      final newUser = _createUserFromFirebase(firebaseUser, role);
      await _dataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      debugPrint('FirebaseAuthRepository: New user created: ${newUser.uid}');
      return newUser;
    } catch (e) {
      debugPrint('FirebaseAuthRepository: Error in signInWithGoogle: $e');
      if (e is AuthException) rethrow;
      throw AuthException('Erreur connexion Google: $e');
    }
  }

  @override
  Future<AppUser> signInWithFacebook(UserRole role) async {
    try {
      final credential = await _dataSource.signInWithFacebook();
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Échec de la connexion Facebook');
      }

      AppUser? existingUser = await _dataSource.getUserProfile(firebaseUser.uid);

      if (existingUser != null) {
        _currentUser = existingUser;
        return existingUser;
      }

      final newUser = _createUserFromFirebase(firebaseUser, role);
      await _dataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      return newUser;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur connexion Facebook: $e');
    }
  }

  @override
  Future<AppUser> signInWithApple(UserRole role) async {
    try {
      final credential = await _dataSource.signInWithApple();
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Échec de la connexion Apple');
      }

      AppUser? existingUser = await _dataSource.getUserProfile(firebaseUser.uid);

      if (existingUser != null) {
        _currentUser = existingUser;
        return existingUser;
      }

      final newUser = _createUserFromFirebase(firebaseUser, role);
      await _dataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      return newUser;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur connexion Apple: $e');
    }
  }

  @override
  Future<AppUser> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _dataSource.signInWithEmailPassword(email, password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Échec de la connexion');
      }

      final user = await _dataSource.getUserProfile(firebaseUser.uid);
      if (user == null) {
        throw AuthException('Profil utilisateur introuvable');
      }

      _currentUser = user;
      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur connexion: $e');
    }
  }

  @override
  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phone,
  }) async {
    try {
      final credential = await _dataSource.registerWithEmailPassword(email, password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Échec de l\'inscription');
      }

      final newUser = AppUser(
        uid: firebaseUser.uid,
        role: role,
        fullName: fullName,
        email: email,
        phone: phone,
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isVerified: firebaseUser.emailVerified,
        clientProfile: role == UserRole.client ? ClientProfile() : null,
        providerProfile: role == UserRole.prestataire ? ProviderProfile() : null,
      );

      await _dataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      return newUser;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur inscription: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
      _currentUser = null;
    } catch (e) {
      // Just log error but don't throw - signOut should always succeed
      debugPrint('SignOut error (ignoring): $e');
      _currentUser = null;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Erreur réinitialisation: $e');
    }
  }

  @override
  Future<void> updateProfile(AppUser user) async {
    try {
      await _dataSource.createOrUpdateUserProfile(user);
      _currentUser = user;
    } catch (e) {
      throw AuthException('Erreur mise à jour profil: $e');
    }
  }

  @override
  Future<void> updateFCMToken(String token, String deviceId) async {
    if (_currentUser == null) return;
    try {
      await _dataSource.updateFCMToken(_currentUser!.uid, token, deviceId);
    } catch (e) {
      // Ne pas bloquer si erreur FCM token
    }
  }

  AppUser _createUserFromFirebase(dynamic firebaseUser, UserRole role) {
    return AppUser(
      uid: firebaseUser.uid,
      role: role,
      fullName: firebaseUser.displayName ?? 'Utilisateur',
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isVerified: firebaseUser.emailVerified,
      clientProfile: role == UserRole.client ? ClientProfile() : null,
      providerProfile: role == UserRole.prestataire ? ProviderProfile() : null,
    );
  }
}
