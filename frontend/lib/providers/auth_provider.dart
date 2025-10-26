import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/models/organization_model.dart';
import 'package:admin_app/services/auth_service.dart';

class AuthState {
  final bool isLoggedIn;
  final User? user;
  final Organization? organization;
  final String? error;
  final bool isLoading;

  AuthState({
    required this.isLoggedIn,
    this.user,
    this.organization,
    this.error,
    required this.isLoading,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    Organization? organization,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      organization: organization ?? this.organization,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService)
      : super(AuthState(isLoggedIn: false, isLoading: false)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final (user, organization) = await _authService.getStoredCredentials();
    if (user != null && organization != null) {
      state = state.copyWith(
        isLoggedIn: true,
        user: user,
        organization: organization,
      );
    }
  }

  Future<void> loginWithOrganization(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final (user, organization) = await _authService.loginWithOrganization(email, password);
      state = state.copyWith(
        isLoggedIn: true,
        user: user,
        organization: organization,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(isLoggedIn: false, isLoading: false);
  }

  Future<void> updateProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.updateProfile(updatedUser);
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
