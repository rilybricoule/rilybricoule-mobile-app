import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyMemberSince = 'member_since';
  static const String _keyAvatarUrl = 'avatar_url';
  static const String _keyLanguage = 'language';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static Future<void> saveUser({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? memberSince,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyMemberSince, memberSince ?? 'Janvier 2024');
    if (avatarUrl != null) await prefs.setString(_keyAvatarUrl, avatarUrl);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_keyUserId),
      'name': prefs.getString(_keyUserName),
      'email': prefs.getString(_keyUserEmail),
      'memberSince': prefs.getString(_keyMemberSince),
      'avatarUrl': prefs.getString(_keyAvatarUrl),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'FR';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
