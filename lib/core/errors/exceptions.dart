/// Erreurs personnalisées pour l'application
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message, [super.code]);
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

class FirestoreException extends AppException {
  FirestoreException(super.message, [super.code]);
}

class NotificationException extends AppException {
  NotificationException(super.message, [super.code]);
}
