import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? userToken;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userToken,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userToken: userToken ?? this.userToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      final token = await _authService.getToken();
      
      state = state.copyWith(
        isAuthenticated: isLoggedIn,
        userToken: token,
      );
    } catch (e) {
      print('❌ Error checking auth status: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final token = await _authService.login(email, password);
      
      if (token != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userToken: token,
          error: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Login failed - no token received',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.register(name, email, password);
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      state = AuthState(); // Reset to initial state
    } catch (e) {
      print('❌ Logout error: $e');
      // Still reset state even if logout fails
      state = AuthState();
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});