import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../core/errors/exceptions.dart';
import '../models/app_user.dart';
import '../../models/user_role.dart';

/// DataSource Firebase Authentication
/// Gère toutes les opérations d'authentification Firebase
/// TODO: Remplacer par API /auth quand backend disponible
class FirebaseAuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Obtenir l'utilisateur Firebase actuel
  firebase_auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  /// Stream de l'état d'authentification
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// ========== SIGN IN WITH GOOGLE ==========
  Future<firebase_auth.UserCredential> signInWithGoogle() async {
    try {
      debugPrint('FirebaseAuthDataSource: Starting Google Sign In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint('FirebaseAuthDataSource: googleUser = $googleUser');
      if (googleUser == null) {
        throw AuthException('Connexion Google annulée', 'google_sign_in_cancelled');
      }

      debugPrint('FirebaseAuthDataSource: Getting authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      debugPrint('FirebaseAuthDataSource: Got accessToken and idToken');
      
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      debugPrint('FirebaseAuthDataSource: Created credential, signing in with Firebase...');

      final result = await _firebaseAuth.signInWithCredential(credential);
      debugPrint('FirebaseAuthDataSource: Firebase sign in successful: ${result.user?.uid}');
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthDataSource: FirebaseAuthException: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      debugPrint('FirebaseAuthDataSource: Error: $e');
      throw AuthException('Erreur lors de la connexion Google: $e');
    }
  }

  /// ========== SIGN IN WITH FACEBOOK ==========
  Future<firebase_auth.UserCredential> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        throw AuthException('Connexion Facebook annulée', 'facebook_sign_in_cancelled');
      }

      if (result.status != LoginStatus.success) {
        throw AuthException('Échec de la connexion Facebook', 'facebook_sign_in_failed');
      }

      final credential = firebase_auth.FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      throw AuthException('Erreur lors de la connexion Facebook: $e');
    }
  }

  /// ========== SIGN IN WITH APPLE ==========
  Future<firebase_auth.UserCredential> signInWithApple() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      throw AuthException('Sign in with Apple disponible uniquement sur iOS/macOS');
    }

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(oauthCredential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      throw AuthException('Erreur lors de la connexion Apple: $e');
    }
  }

  /// ========== EMAIL/PASSWORD SIGN IN ==========
  Future<firebase_auth.UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    }
  }

  /// ========== EMAIL/PASSWORD REGISTER ==========
  Future<firebase_auth.UserCredential> registerWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    }
  }

  /// ========== SIGN OUT ==========
  Future<void> signOut() async {
    // Sign out from each provider individually - don't let one failure stop others
    
    // 1. Firebase Auth (always try this)
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Firebase signOut error (ignoring): $e');
    }
    
    // 2. Google Sign In (optional)
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google signOut error (ignoring): $e');
    }
    
    // 3. Facebook (optional - may not be initialized)
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      debugPrint('Facebook logout error (ignoring): $e');
    }
  }

  /// ========== RESET PASSWORD ==========
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    }
  }

  /// ========== FIRESTORE USER PROFILE ==========
  
  /// Créer ou mettre à jour le profil utilisateur dans Firestore
  Future<void> createOrUpdateUserProfile(AppUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
            user.toFirestore(),
            SetOptions(merge: true),
          );
    } on FirebaseException catch (e) {
      throw FirestoreException('Erreur Firestore: ${e.message}', e.code);
    }
  }

  /// Récupérer le profil utilisateur depuis Firestore
  Future<AppUser?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirestoreException('Erreur Firestore: ${e.message}', e.code);
    }
  }

  /// Mettre à jour le FCM token
  Future<void> updateFCMToken(String uid, String token, String deviceId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fcmTokens.$deviceId': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirestoreException('Erreur mise à jour FCM token: ${e.message}', e.code);
    }
  }

  /// Supprimer le FCM token
  Future<void> removeFCMToken(String uid, String deviceId) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fcmTokens.$deviceId': FieldValue.delete(),
      });
    } catch (e) {
      // Ignorer les erreurs de suppression de token
    }
  }

  /// Messages d'erreur en français
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      case 'network-request-failed':
        return 'Erreur réseau. Vérifiez votre connexion';
      default:
        return 'Une erreur est survenue';
    }
  }
}
