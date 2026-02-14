import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isObscure = true;
  bool get isObscure => _isObscure;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    
    _isLoading = false;
    notifyListeners();
    
    // Check if email and password are valid (mock logic)
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    
    return true;
  }
}
