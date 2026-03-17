/// Configuration globale de l'application
class AppConfig {
  /// Flag pour activer/désactiver l'authentification backend
  /// 
  /// - false: Mode Firebase-only (actuel, mock)
  /// - true: Mode Backend JWT (Firebase → Backend → JWT)
  /// 
  /// TODO: Passer à true quand le backend Spring Boot est prêt
  static const bool USE_BACKEND_AUTH = false;
  
  /// Flag pour activer/désactiver le profil backend
  /// 
  /// - false: Mode Firebase (Firestore + Storage)
  /// - true: Mode API Backend (/users/me, etc.)
  /// 
  /// TODO: Passer à true quand les endpoints backend sont prêts
  static const bool USE_BACKEND_PROFILE = false;

  /// Flag pour activer/désactiver le paiement backend
  /// 
  /// - false: Mode Mock (données en mémoire, perdues à la fermeture)
  /// - true: Mode API Backend (cartes sauvegardées côté serveur, persistées)
  /// 
  /// TODO: Passer à true quand les endpoints CMI/paiement sont prêts
  static const bool USE_BACKEND_PAYMENT = false;  // ← TEMP: false (mock mode)
  
  /// URL du backend Spring Boot
  /// TODO: Remplacer par l'URL de production
  static const String BACKEND_BASE_URL = 'http://localhost:8080/api';
  
  /// Timeout des requêtes HTTP (en secondes)
  static const int HTTP_TIMEOUT = 30;
  
  /// Durée de validité du token avant refresh (en secondes)
  /// Le backend renvoie expiresIn, mais on refresh 5min avant
  static const int TOKEN_REFRESH_BUFFER = 300; // 5 minutes
}
