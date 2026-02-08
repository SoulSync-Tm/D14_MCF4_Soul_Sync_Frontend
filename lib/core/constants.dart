class AppConstants {
  // API Configuration
  static const String baseUrl = "http://localhost:8000";
  
  // Storage Keys
  static const String tokenKey = "auth_token";
  static const String userKey = "user_data";
  static const String refreshTokenKey = "refresh_token";
  
  // API Endpoints
  static const String loginEndpoint = "/api/v1/auth/login";
  static const String registerEndpoint = "/api/v1/auth/register";
  static const String feedEndpoint = "/users/feed";
  static const String identifySongEndpoint = "/songs/identify";
  static const String analyzeEmotionEndpoint = "/emotions/analyze";
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}