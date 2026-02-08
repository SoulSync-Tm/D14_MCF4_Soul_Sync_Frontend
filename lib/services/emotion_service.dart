import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/emotion_session.dart';

class EmotionService {
  static final EmotionService _instance = EmotionService._internal();
  factory EmotionService() => _instance;
  EmotionService._internal();

  final ApiClient _apiClient = ApiClient();

  /// Analyze emotion from video and audio files
  Future<EmotionSession> analyzeSession(String videoPath, String audioPath) async {
    try {
      print('📹 Analyzing emotion session...');
      print('Video: $videoPath');
      print('Audio: $audioPath');
      
      // Check if files exist
      final videoFile = File(videoPath);
      final audioFile = File(audioPath);
      
      if (!await videoFile.exists()) {
        throw Exception('Video file not found: $videoPath');
      }
      
      if (!await audioFile.exists()) {
        throw Exception('Audio file not found: $audioPath');
      }

      // Create form data with both files
      final formData = FormData.fromMap({
        'video_file': await MultipartFile.fromFile(
          videoPath,
          filename: 'emotion_video.${videoPath.split('.').last}',
        ),
        'audio_file': await MultipartFile.fromFile(
          audioPath,
          filename: 'emotion_audio.${audioPath.split('.').last}',
        ),
      });

      final response = await _apiClient.post(
        AppConstants.analyzeEmotionEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          // Increase timeout for emotion analysis
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final emotionSession = EmotionSession.fromJson(data);
        print('✓ Emotion analysis completed: ${emotionSession.emotion} (${emotionSession.confidence})');
        return emotionSession;
      } else {
        throw Exception('Emotion analysis failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Emotion analysis error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['detail'] != null) {
          throw Exception('Invalid files: ${errorData['detail']}');
        }
        throw Exception('Invalid video or audio files');
      } else if (e.response?.statusCode == 413) {
        throw Exception('Files too large. Please use smaller files.');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Unsupported file format');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Analysis timeout. Please try with shorter files.');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected emotion analysis error: $e');
      throw Exception('Emotion analysis failed');
    }
  }

  /// Analyze emotion from audio only
  Future<EmotionSession> analyzeAudioOnly(String audioPath) async {
    try {
      print('🎤 Analyzing emotion from audio only...');
      print('Audio: $audioPath');
      
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        throw Exception('Audio file not found: $audioPath');
      }

      final formData = FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(
          audioPath,
          filename: 'emotion_audio.${audioPath.split('.').last}',
        ),
      });

      final response = await _apiClient.post(
        '/emotions/analyze-audio',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          receiveTimeout: const Duration(minutes: 1),
          sendTimeout: const Duration(minutes: 1),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final emotionSession = EmotionSession.fromJson(data);
        print('✓ Audio emotion analysis completed: ${emotionSession.emotion}');
        return emotionSession;
      } else {
        throw Exception('Audio emotion analysis failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Audio emotion analysis error: ${e.message}');
      throw Exception('Audio emotion analysis failed');
    } catch (e) {
      print('❌ Unexpected audio emotion analysis error: $e');
      throw Exception('Audio emotion analysis failed');
    }
  }

  /// Get user's emotion history
  Future<List<EmotionSession>> getEmotionHistory() async {
    try {
      print('📈 Fetching emotion history...');
      final response = await _apiClient.get('/emotions/history');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final sessions = data
            .map((e) => EmotionSession.fromJson(e as Map<String, dynamic>))
            .toList();
        print('✓ Loaded ${sessions.length} emotion sessions');
        return sessions;
      } else {
        throw Exception('Failed to load emotion history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Emotion history error: ${e.message}');
      throw Exception('Failed to load emotion history');
    } catch (e) {
      print('❌ Unexpected emotion history error: $e');
      throw Exception('Failed to load emotion history');
    }
  }

  /// Get emotion-based music recommendations
  Future<List<Song>> getEmotionRecommendations(String emotion) async {
    try {
      print('🎵 Getting recommendations for emotion: $emotion');
      final response = await _apiClient.get(
        '/emotions/recommendations',
        queryParameters: {'emotion': emotion},
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final songs = data
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList();
        print('✓ Found ${songs.length} recommendations for $emotion');
        return songs;
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Emotion recommendations error: ${e.message}');
      throw Exception('Failed to get emotion-based recommendations');
    } catch (e) {
      print('❌ Unexpected emotion recommendations error: $e');
      throw Exception('Failed to get recommendations');
    }
  }
}