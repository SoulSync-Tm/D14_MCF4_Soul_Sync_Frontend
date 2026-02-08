import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/api_client.dart';
import '../core/constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login user with email and password (form-encoded for FastAPI OAuth2)
  Future<String?> login(String email, String password) async {
    try {
      print('🔐 Attempting login for: $email');
      final response = await _apiClient.post(
        AppConstants.loginEndpoint,
        data: {
          'username': email, // FastAPI OAuth2 uses 'username' not 'email'
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['access_token'] as String?;
        
        if (token != null) {
          // Store token securely
          await _storage.write(key: AppConstants.tokenKey, value: token);
          
          // Store user data if provided
          if (data['user'] != null) {
            await _storage.write(
              key: AppConstants.userKey, 
              value: jsonEncode(data['user'])
            );
          }

          print('✅ Login successful for $email');
          return token;
        } else {
          throw Exception('No access token received from server');
        }
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Login error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Invalid request format');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected login error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  /// Register new user (JSON body for FastAPI)
  Future<void> register(String name, String email, String password) async {
    try {
      print('📝 Attempting registration for: $email');
      final response = await _apiClient.post(
        AppConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Registration successful for $email');
      } else {
        throw Exception('Registration failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Registration error: ${e.message}');
      if (e.response?.statusCode == 409) {
        throw Exception('Email already exists');
      } else if (e.response?.statusCode == 422) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['detail'] != null) {
          throw Exception(errorData['detail']);
        }
        throw Exception('Invalid registration data');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected registration error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  /// Logout user and clear stored data
  Future<void> logout() async {
    try {
      // Call logout endpoint (optional - depends on backend implementation)
      try {
        await _apiClient.post('/auth/logout');
      } catch (e) {
        // Ignore logout endpoint errors, still clear local storage
        print('⚠️ Logout endpoint error (ignoring): $e');
      }

      // Clear all stored authentication data
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
      await _storage.delete(key: AppConstants.userKey);

      print('✓ Logout successful - all data cleared');
    } catch (e) {
      print('❌ Logout error: $e');
      // Even if logout fails, clear local storage
      await _storage.deleteAll();
      throw Exception('Logout failed, but local data was cleared');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: AppConstants.tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: AppConstants.userKey);
      if (userData != null) {
        return jsonDecode(userData) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  /// Get stored auth token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.tokenKey);
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }
}