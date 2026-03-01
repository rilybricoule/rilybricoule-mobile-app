import '../../data/models/app_user.dart';
import '../../models/user_role.dart';

/// Interface du repository d'authentification
/// Permet de changer l'implémentation (Firebase -> API) sans toucher au reste du code
abstract class AuthRepository {
  /// Stream de l'utilisateur connecté
  Stream<AppUser?> get authStateChanges;

  /// Utilisateur actuel
  AppUser? get currentUser;

  /// Connexion avec Google
  Future<AppUser> signInWithGoogle(UserRole role);

  /// Connexion avec Facebook
  Future<AppUser> signInWithFacebook(UserRole role);

  /// Connexion avec Apple
  Future<AppUser> signInWithApple(UserRole role);

  /// Connexion avec email/password
  Future<AppUser> signInWithEmailPassword(String email, String password);

  /// Inscription avec email/password
  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phone,
  });

  /// Déconnexion
  Future<void> signOut();

  /// Réinitialiser le mot de passe
  Future<void> sendPasswordResetEmail(String email);

  /// Mettre à jour le profil
  Future<void> updateProfile(AppUser user);

  /// Mettre à jour le FCM token
  Future<void> updateFCMToken(String token, String deviceId);
}
