import '../../../models/user.dart';
import '../../../models/user_role.dart';
import '../domain/auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  // TODO: Inject HTTP client (e.g., Dio, http package)
  // final HttpClient _httpClient;
  
  // TODO: Add base URL configuration
  // final String _baseUrl;

  @override
  Future<User> login(String email, String password) async {
    // TODO: Implement when backend API is ready
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/login',
    //   body: {'email': email, 'password': password},
    // );
    // return User.fromJson(response.data);
    throw UnimplementedError('API login not implemented yet');
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    Map<String, dynamic>? extraData,
  }) async {
    // TODO: Implement when backend API is ready
    // Example:
    // final response = await _httpClient.post(
    //   '$_baseUrl/auth/register',
    //   body: {
    //     'email': email,
    //     'password': password,
    //     'name': name,
    //     'role': role.name,
    //     ...?extraData,
    //   },
    // );
    // return User.fromJson(response.data);
    throw UnimplementedError('API register not implemented yet');
  }

  @override
  Future<void> logout() async {
    // TODO: Implement when backend API is ready
    // Example:
    // await _httpClient.post('$_baseUrl/auth/logout');
    // Clear local storage/tokens
    throw UnimplementedError('API logout not implemented yet');
  }

  @override
  Future<User?> getCurrentUser() async {
    // TODO: Implement when backend API is ready
    // Example:
    // final token = await _storage.getToken();
    // if (token == null) return null;
    // final response = await _httpClient.get('$_baseUrl/auth/me');
    // return User.fromJson(response.data);
    throw UnimplementedError('API getCurrentUser not implemented yet');
  }
}
