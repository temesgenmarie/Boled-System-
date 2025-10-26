import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/models/organization_model.dart';
import 'dart:convert';

class AuthService {
  static const String _userKey = 'stored_user';
  static const String _organizationKey = 'stored_organization';

  static const String _sampleEmail = 'admin@organization.com';
  static const String _samplePassword = 'password123';

  Future<(User, Organization)> loginWithOrganization(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (email != _sampleEmail || password != _samplePassword) {
      throw Exception('Invalid email or password. Use sample credentials to login.');
    }

    final organization = Organization(
      id: '1',
      name: 'Funeral Services Organization',
      email: email,
      password: password,
      address: '123 Main Street, New York, NY 10001',
      status: 'active',
      createdAt: DateTime.now(),
    );

    final user = User(
      id: '1',
      firstName: 'Admin',
      lastName: 'User',
      email: email,
      phone: '+1 (555) 123-4567',
      organizationId: organization.id,
      role: 'admin',
      lastLoginTime: DateTime.now(),
      isActive: true,
      createdAt: DateTime.now(),
    );

    await _storeCredentials(user, organization);
    return (user, organization);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_organizationKey);
  }

  Future<(User?, Organization?)> getStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    final organizationJson = prefs.getString(_organizationKey);
    
    if (userJson != null && organizationJson != null) {
      return (
        User.fromJson(jsonDecode(userJson)),
        Organization.fromJson(jsonDecode(organizationJson)),
      );
    }
    return (null, null);
  }

  Future<void> _storeCredentials(User user, Organization organization) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_organizationKey, jsonEncode(organization.toJson()));
  }

  Future<User> updateProfile(User updatedUser) async {
    // TODO: Replace with actual API call
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      final currentUser = User.fromJson(jsonDecode(userJson));
      final user = currentUser.copyWith(
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        phone: updatedUser.phone,
      );
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      return user;
    }
    
    return updatedUser;
  }
}
