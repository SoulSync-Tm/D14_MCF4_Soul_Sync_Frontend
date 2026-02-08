import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void initialize() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token if available
          final token = await _storage.read(key: AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          print('📡 ${options.method} ${options.path}');
          print('📤 Headers: ${options.headers}');
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          print('❌ Error ${error.response?.statusCode} ${error.requestOptions.path}');
          print('❌ Message: ${error.message}');
          
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            print('🔒 Unauthorized - clearing token');
            await _storage.delete(key: AppConstants.tokenKey);
            await _storage.delete(key: AppConstants.userKey);
            // TODO: Navigate to login screen
          }
          
          handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}