/// EXEMPLES D'UTILISATION - Architecture Auth Backend

// ============================================
// 1. CONFIGURATION INITIALE (main.dart)
// ============================================

import 'package:rilybricoule_mobile_app/services/api/api_client.dart';
import 'package:rilybricoule_mobile_app/data/repositories/hybrid_auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  // Initialiser ApiClient (IMPORTANT)
  ApiClient().initialize();
  
  // Créer le repository hybride
  final authDataSource = FirebaseAuthDataSource();
  final backendDataSource = BackendAuthDataSource();
  final authRepository = HybridAuthRepository(
    firebaseDataSource: authDataSource,
    backendDataSource: backendDataSource,
  );
  
  runApp(MyApp(authRepository: authRepository));
}

// ============================================
// 2. LOGIN AVEC GOOGLE (AuthViewModel)
// ============================================

// Le code du ViewModel ne change PAS
// L'architecture gère automatiquement Firebase vs Backend

Future<AppUser?> signInWithGoogle(UserRole role) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // Si USE_BACKEND_AUTH = false: Firebase only
    // Si USE_BACKEND_AUTH = true: Firebase → Backend → JWT
    _currentUser = await _authRepository.signInWithGoogle(role);
    
    _isLoading = false;
    notifyListeners();
    return _currentUser;
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    return null;
  }
}

// ============================================
// 3. APPEL API AVEC JWT (Exemple: BookingRepository)
// ============================================

import 'package:rilybricoule_mobile_app/services/api/api_client.dart';

class BookingRepository {
  final _apiClient = ApiClient();
  
  /// Créer une réservation
  /// Le JWT est ajouté automatiquement par l'interceptor
  Future<Booking> createBooking(BookingRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/bookings',
        data: request.toJson(),
      );
      
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      // Si 401, l'interceptor refresh automatiquement et retry
      throw Exception('Failed to create booking: ${e.message}');
    }
  }
  
  /// Récupérer les réservations de l'utilisateur
  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _apiClient.dio.get('/bookings/me');
      
      final List<dynamic> data = response.data;
      return data.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get bookings: $e');
    }
  }
}

// ============================================
// 4. VÉRIFIER L'ÉTAT DE LA SESSION (SplashScreen)
// ============================================

import 'package:rilybricoule_mobile_app/services/storage/token_storage.dart';
import 'package:rilybricoule_mobile_app/core/config/app_config.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _tokenStorage = TokenStorage();
  
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  
  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));
    
    if (AppConfig.USE_BACKEND_AUTH) {
      // Mode Backend: vérifier les tokens JWT
      final hasValidTokens = await _tokenStorage.hasValidTokens();
      
      if (hasValidTokens) {
        // Charger le profil et naviguer selon le rôle
        final authViewModel = context.read<AuthViewModel>();
        final user = authViewModel.currentUser;
        
        if (user != null) {
          if (user.role == UserRole.client) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.providerMain);
          }
          return;
        }
      }
    } else {
      // Mode Firebase: vérifier Firebase Auth
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Charger depuis Firestore et naviguer
        // ... code existant
      }
    }
    
    // Pas de session → Welcome
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }
}

// ============================================
// 5. LOGOUT COMPLET
// ============================================

Future<void> logout() async {
  // AuthViewModel
  await _authRepository.signOut();
  _currentUser = null;
  notifyListeners();
}

// Dans le repository, signOut() fait:
// 1. FirebaseAuth.signOut()
// 2. POST /auth/logout (si backend)
// 3. TokenStorage.clearAll()

// ============================================
// 6. REFRESH TOKEN MANUEL (si besoin)
// ============================================

import 'package:rilybricoule_mobile_app/services/storage/token_storage.dart';
import 'package:rilybricoule_mobile_app/data/datasources/backend_auth_datasource.dart';

Future<void> refreshTokenIfNeeded() async {
  final tokenStorage = TokenStorage();
  final tokens = await tokenStorage.getTokens();
  
  if (tokens != null && tokens.shouldRefresh) {
    final backendDataSource = BackendAuthDataSource();
    final newTokens = await backendDataSource.refreshToken(tokens.refreshToken);
    await tokenStorage.saveTokens(newTokens);
  }
}

// NOTE: Le refresh est automatique via l'interceptor,
// pas besoin de l'appeler manuellement

// ============================================
// 7. RÉCUPÉRER LE PROFIL BACKEND
// ============================================

import 'package:rilybricoule_mobile_app/data/repositories/hybrid_auth_repository.dart';

// Si vous avez besoin du BackendUser (avec metadata, etc.)
final authRepo = context.read<AuthRepository>() as HybridAuthRepository;
final backendUser = authRepo.backendUser;

if (backendUser != null) {
  print('User ID: ${backendUser.id}');
  print('Role: ${backendUser.role}');
  print('Metadata: ${backendUser.metadata}');
}

// ============================================
// 8. TESTER LES 2 MODES
// ============================================

// Mode Firebase-only (actuel)
// Dans app_config.dart:
static const bool USE_BACKEND_AUTH = false;

// Comportement:
// - Login → Firebase Auth
// - Profil → Firestore
// - Rôle → Firestore
// - Pas de JWT

// Mode Backend JWT (futur)
// Dans app_config.dart:
static const bool USE_BACKEND_AUTH = true;

// Comportement:
// - Login → Firebase Auth → Backend
// - Firebase ID Token → Backend
// - Backend → JWT
// - Profil → Backend API
// - Rôle → Backend
// - Toutes APIs → JWT

// ============================================
// 9. GÉRER LES ERREURS D'API
// ============================================

try {
  final booking = await bookingRepository.createBooking(request);
  // Success
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // Token expiré et refresh a échoué
    // Forcer logout
    await authViewModel.logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
  } else if (e.response?.statusCode == 403) {
    // Accès refusé (permissions)
    showError('Vous n\'avez pas les permissions');
  } else {
    showError('Erreur: ${e.message}');
  }
}

// ============================================
// 10. AJOUTER UN NOUVEAU REPOSITORY API
// ============================================

import 'package:rilybricoule_mobile_app/services/api/api_client.dart';

class ChatRepository {
  final _apiClient = ApiClient();
  
  Future<List<Conversation>> getConversations() async {
    // Le JWT est ajouté automatiquement
    final response = await _apiClient.dio.get('/conversations');
    return (response.data as List)
        .map((json) => Conversation.fromJson(json))
        .toList();
  }
  
  Future<void> sendMessage(String conversationId, String text) async {
    await _apiClient.dio.post(
      '/conversations/$conversationId/messages',
      data: {'text': text},
    );
  }
}

// IMPORTANT: Ne JAMAIS utiliser Firebase ID Token pour les APIs métier
// Toujours utiliser ApiClient qui ajoute le JWT backend
