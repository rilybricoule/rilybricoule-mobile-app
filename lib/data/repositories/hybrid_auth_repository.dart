import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/backend_auth_datasource.dart';
import '../models/app_user.dart';
import '../models/auth_tokens.dart';
import '../models/backend_user.dart';
import '../../models/user_role.dart';
import '../../core/errors/exceptions.dart';
import '../../core/config/app_config.dart';
import '../../services/storage/token_storage.dart';

/// Implémentation hybride du AuthRepository
/// - Si USE_BACKEND_AUTH = false: Firebase only (mode actuel)
/// - Si USE_BACKEND_AUTH = true: Firebase → Backend → JWT
class HybridAuthRepository implements AuthRepository {
  final FirebaseAuthDataSource _firebaseDataSource;
  final BackendAuthDataSource _backendDataSource;
  final TokenStorage _tokenStorage;
  
  AppUser? _currentUser;
  BackendUser? _backendUser;

  HybridAuthRepository({
    required FirebaseAuthDataSource firebaseDataSource,
    required BackendAuthDataSource backendDataSource,
    TokenStorage? tokenStorage,
  })  : _firebaseDataSource = firebaseDataSource,
        _backendDataSource = backendDataSource,
        _tokenStorage = tokenStorage ?? TokenStorage() {
    // Écouter les changements d'auth Firebase
    _firebaseDataSource.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        if (AppConfig.USE_BACKEND_AUTH) {
          // Mode backend: charger depuis backend
          await _loadBackendUser();
        } else {
          // Mode Firebase: charger depuis Firestore
          _currentUser = await _firebaseDataSource.getUserProfile(firebaseUser.uid);
        }
      } else {
        _currentUser = null;
        _backendUser = null;
      }
    });
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _firebaseDataSource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      if (AppConfig.USE_BACKEND_AUTH) {
        // Charger depuis backend
        await _loadBackendUser();
        return _convertBackendUserToAppUser(_backendUser!);
      } else {
        // Charger depuis Firestore
        return await _firebaseDataSource.getUserProfile(firebaseUser.uid);
      }
    });
  }

  @override
  AppUser? get currentUser => _currentUser;

  BackendUser? get backendUser => _backendUser;

  @override
  Future<AppUser> signInWithGoogle(UserRole role) async {
    try {
      debugPrint('HybridAuthRepository: Google Sign In...');
      
      // 1. Firebase Auth
      final credential = await _firebaseDataSource.signInWithGoogle();
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw AuthException('Firebase user is null');
      }

      if (AppConfig.USE_BACKEND_AUTH) {
        // 2. Récupérer Firebase ID Token
        final idToken = await firebaseUser.getIdToken(true);
        if (idToken == null) {
          throw AuthException('Failed to get Firebase ID Token');
        }

        // 3. Envoyer au backend
        final backendResponse = await _backendDataSource.authenticateWithFirebase(idToken);
        
        // 4. Sauvegarder les tokens JWT
        final tokens = AuthTokens.fromJson(backendResponse);
        await _tokenStorage.saveTokens(tokens);
        
        // 5. Récupérer le profil backend
        _backendUser = BackendUser.fromJson(backendResponse['user']);
        await _tokenStorage.saveUserId(_backendUser!.id);
        
        // 6. Convertir en AppUser
        _currentUser = _convertBackendUserToAppUser(_backendUser!);
        return _currentUser!;
      } else {
        // Mode Firebase-only
        AppUser? existingUser = await _firebaseDataSource.getUserProfile(firebaseUser.uid);
        
        if (existingUser != null) {
          _currentUser = existingUser;
          return existingUser;
        }

        final newUser = _createUserFromFirebase(firebaseUser, role);
        await _firebaseDataSource.createOrUpdateUserProfile(newUser);
        _currentUser = newUser;
        return newUser;
      }
    } catch (e) {
      debugPrint('HybridAuthRepository: Error: $e');
      if (e is AuthException) rethrow;
      throw AuthException('Erreur connexion Google: $e');
    }
  }

  @override
  Future<AppUser> signInWithFacebook(UserRole role) async {
    final credential = await _firebaseDataSource.signInWithFacebook();
    return await _handleSocialSignIn(credential, role);
  }

  @override
  Future<AppUser> signInWithApple(UserRole role) async {
    final credential = await _firebaseDataSource.signInWithApple();
    return await _handleSocialSignIn(credential, role);
  }

  Future<AppUser> _handleSocialSignIn(
    firebase_auth.UserCredential credential,
    UserRole role,
  ) async {
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw AuthException('Firebase user is null');
    }

    if (AppConfig.USE_BACKEND_AUTH) {
      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null) throw AuthException('Failed to get Firebase ID Token');

      final backendResponse = await _backendDataSource.authenticateWithFirebase(idToken);
      final tokens = AuthTokens.fromJson(backendResponse);
      await _tokenStorage.saveTokens(tokens);
      
      _backendUser = BackendUser.fromJson(backendResponse['user']);
      await _tokenStorage.saveUserId(_backendUser!.id);
      
      _currentUser = _convertBackendUserToAppUser(_backendUser!);
      return _currentUser!;
    } else {
      AppUser? existingUser = await _firebaseDataSource.getUserProfile(firebaseUser.uid);
      
      if (existingUser != null) {
        _currentUser = existingUser;
        return existingUser;
      }

      final newUser = _createUserFromFirebase(firebaseUser, role);
      await _firebaseDataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      return newUser;
    }
  }

  @override
  Future<AppUser> signInWithEmailPassword(String email, String password) async {
    final credential = await _firebaseDataSource.signInWithEmailPassword(email, password);
    final firebaseUser = credential.user;
    if (firebaseUser == null) throw AuthException('Firebase user is null');

    if (AppConfig.USE_BACKEND_AUTH) {
      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null) throw AuthException('Failed to get Firebase ID Token');

      final backendResponse = await _backendDataSource.authenticateWithFirebase(idToken);
      final tokens = AuthTokens.fromJson(backendResponse);
      await _tokenStorage.saveTokens(tokens);
      
      _backendUser = BackendUser.fromJson(backendResponse['user']);
      await _tokenStorage.saveUserId(_backendUser!.id);
      
      _currentUser = _convertBackendUserToAppUser(_backendUser!);
      return _currentUser!;
    } else {
      final user = await _firebaseDataSource.getUserProfile(firebaseUser.uid);
      if (user == null) throw AuthException('User profile not found');
      _currentUser = user;
      return user;
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
    final credential = await _firebaseDataSource.registerWithEmailPassword(email, password);
    final firebaseUser = credential.user;
    if (firebaseUser == null) throw AuthException('Firebase user is null');

    if (AppConfig.USE_BACKEND_AUTH) {
      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null) throw AuthException('Failed to get Firebase ID Token');

      final backendResponse = await _backendDataSource.authenticateWithFirebase(idToken);
      final tokens = AuthTokens.fromJson(backendResponse);
      await _tokenStorage.saveTokens(tokens);
      
      _backendUser = BackendUser.fromJson(backendResponse['user']);
      await _tokenStorage.saveUserId(_backendUser!.id);
      
      _currentUser = _convertBackendUserToAppUser(_backendUser!);
      return _currentUser!;
    } else {
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

      await _firebaseDataSource.createOrUpdateUserProfile(newUser);
      _currentUser = newUser;
      return newUser;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseDataSource.signOut();
      
      if (AppConfig.USE_BACKEND_AUTH) {
        await _backendDataSource.logout();
        await _tokenStorage.clearAll();
      }
      
      _currentUser = null;
      _backendUser = null;
    } catch (e) {
      debugPrint('SignOut error (ignoring): $e');
      _currentUser = null;
      _backendUser = null;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> updateProfile(AppUser user) async {
    await _firebaseDataSource.createOrUpdateUserProfile(user);
    _currentUser = user;
  }

  @override
  Future<void> updateFCMToken(String token, String deviceId) async {
    if (_currentUser == null) return;
    await _firebaseDataSource.updateFCMToken(_currentUser!.uid, token, deviceId);
  }

  Future<void> _loadBackendUser() async {
    try {
      _backendUser = await _backendDataSource.getMe();
      _currentUser = _convertBackendUserToAppUser(_backendUser!);
    } catch (e) {
      debugPrint('Failed to load backend user: $e');
    }
  }

  AppUser _convertBackendUserToAppUser(BackendUser backendUser) {
    return AppUser(
      uid: backendUser.id,
      role: backendUser.role,
      fullName: backendUser.fullName,
      email: backendUser.email,
      phone: backendUser.phone,
      photoUrl: backendUser.photoUrl,
      createdAt: backendUser.createdAt,
      updatedAt: backendUser.updatedAt,
      isVerified: backendUser.isVerified,
      clientProfile: backendUser.role == UserRole.client ? ClientProfile() : null,
      providerProfile: backendUser.role == UserRole.prestataire ? ProviderProfile() : null,
    );
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
