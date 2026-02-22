import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../models/user_role.dart';
import '../domain/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthViewModel(this._authRepository);
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isObscure = true;
  bool get isObscure => _isObscure;

  User? _currentUser;
  User? get currentUser => _currentUser;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authRepository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<User?> register(String email, String password, String name, UserRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    
    return true;
  }
  
  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
