import '../../core/config/app_config.dart';
import '../../data/datasources/mock_payment_datasource.dart';
import '../../data/datasources/api_payment_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';

/// Factory pour créer le PaymentRepository
/// 
/// Configure la source de données selon les flags de configuration.
/// 
/// Usage:
/// ```dart
/// final paymentRepository = PaymentService.createRepository();
/// ```
class PaymentService {
  // Singleton instance of MockPaymentDataSource to share data across screens
  static final MockPaymentDataSource _mockDataSource = MockPaymentDataSource();

  /// Créer une instance de PaymentRepository
  /// 
  /// Retourne un repository configuré avec la bonne source de données
  /// selon le flag AppConfig.USE_BACKEND_PAYMENT.
  /// 
  /// - Si USE_BACKEND_PAYMENT = true: Utilise ApiPaymentDataSource pour
  ///   persister les cartes côté serveur (restent après réinstall)
  /// - Si USE_BACKEND_PAYMENT = false: Utilise MockPaymentDataSource pour
  ///   le développement (données en mémoire uniquement)
  static PaymentRepository createRepository() {
    return PaymentRepositoryImpl(
      dataSource: AppConfig.USE_BACKEND_PAYMENT
          ? ApiPaymentDataSource()
          : _mockDataSource,  // Use singleton for shared data
    );
  }

  /// Créer un repository avec une source de données mock spécifique
  /// 
  /// Utile pour les tests avec données injectées
  static PaymentRepository createMockRepository(MockPaymentDataSource dataSource) {
    return PaymentRepositoryImpl(dataSource: dataSource);
  }
}
