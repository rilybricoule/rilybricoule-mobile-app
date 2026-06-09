import '../../core/config/app_config.dart';
import '../../data/datasources/api_profile_datasource.dart';
import '../../data/datasources/firebase_profile_datasource.dart';
import '../../data/datasources/profile_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';

/// Factory pour créer le ProfileRepository avec la bonne configuration
/// 
/// Permet de switcher entre Firebase et API backend sans modifier le reste du code.
/// Usage: final profileRepo = ProfileService.createRepository();
class ProfileService {
  /// Créer le ProfileRepository configuré selon AppConfig.USE_BACKEND_PROFILE
  static ProfileRepository createRepository() {
    final ProfileDataSource dataSource;
    
    if (AppConfig.USE_BACKEND_PROFILE) {
      // Mode Backend API
      dataSource = ApiProfileDataSource();
    } else {
      // Mode Firebase
      dataSource = FirebaseProfileDataSource();
    }
    
    return ProfileRepositoryImpl(dataSource: dataSource);
  }
  
  /// Créer explicitement avec Firebase (pour tests ou fallback)
  static ProfileRepository createFirebaseRepository() {
    return ProfileRepositoryImpl(
      dataSource: FirebaseProfileDataSource(),
    );
  }
  
  /// Créer explicitement avec API (quand backend est prêt)
  static ProfileRepository createApiRepository() {
    return ProfileRepositoryImpl(
      dataSource: ApiProfileDataSource(),
    );
  }
}
