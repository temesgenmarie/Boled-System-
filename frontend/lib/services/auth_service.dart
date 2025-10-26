import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_app/models/user_model.dart';
import 'dart:convert';

class AuthService {
  static const String _userKey = 'stored_user';

  Future<User?> login(String username, String password) async {
    // TODO: Replace with actual API call
    // For demo purposes, accepting any non-empty credentials
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    final user = User(
      id: '1',
      username: username,
      organizationName: 'Sample Organization',
      lastLoginTime: DateTime.now(),
    );

    await _storeUser(user);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<User> updateProfile(String username, String password) async {
    // TODO: Replace with actual API call
    final user = User(
      id: '1',
      username: username,
      organizationName: 'Sample Organization',
      lastLoginTime: DateTime.now(),
    );
    await _storeUser(user);
    return user;
  }
}
