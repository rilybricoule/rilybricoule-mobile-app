import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../data/models/app_user.dart';
import '../../../models/user_role.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _disposed = false;
  
  AuthViewModel(this._authRepository);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isObscure = true;
  bool get isObscure => _isObscure;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<AppUser?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authRepository.signInWithEmailPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<AppUser?> register(String email, String password, String fullName, UserRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authRepository.registerWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
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

  Future<AppUser?> signInWithGoogle(UserRole role) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      debugPrint('AuthViewModel: Calling repository.signInWithGoogle...');
      _currentUser = await _authRepository.signInWithGoogle(role);
      debugPrint('AuthViewModel: Repository returned user: ${_currentUser?.uid}');
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e, stackTrace) {
      debugPrint('AuthViewModel: Google Sign In Error: $e');
      debugPrint('AuthViewModel: StackTrace: $stackTrace');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<AppUser?> signInWithFacebook(UserRole role) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authRepository.signInWithFacebook(role);
      _isLoading = false;
      notifyListeners();
      return _currentUser;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<AppUser?> signInWithApple(UserRole role) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authRepository.signInWithApple(role);
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

    try {
      await _authRepository.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _authRepository.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
