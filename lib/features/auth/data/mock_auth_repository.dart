import '../../../models/user.dart';
import '../../../models/user_role.dart';
import '../domain/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    // Mock role detection: if email contains "pro", user is prestataire
    final role = email.toLowerCase().contains('pro')
        ? UserRole.prestataire
        : UserRole.client;

    _currentUser = User(
      id: '1',
      email: email,
      name: 'User',
      role: role,
    );

    return _currentUser!;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    Map<String, dynamic>? extraData,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _currentUser = User(
      id: '1',
      email: email,
      name: name,
      role: role,
    );

    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }
}
