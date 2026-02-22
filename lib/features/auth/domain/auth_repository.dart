import '../../../models/user.dart';
import '../../../models/user_role.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  
  Future<User> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    Map<String, dynamic>? extraData,
  });
  
  Future<void> logout();
  
  Future<User?> getCurrentUser();
}
