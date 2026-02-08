import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/user_feed.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final ApiClient _apiClient = ApiClient();

  /// Get user's home feed with playlists, recent songs, and recommendations
  Future<UserFeed> getHomeFeed() async {
    try {
      print('🏠 Fetching home feed...');
      final response = await _apiClient.get(AppConstants.feedEndpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final userFeed = UserFeed.fromJson(data);
        print('✓ Home feed loaded successfully');
        return userFeed;
      } else {
        throw Exception('Failed to load home feed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Home feed error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Feed not found');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected home feed error: $e');
      throw Exception('Failed to load home feed');
    }
  }

  /// Get specific playlist by ID
  Future<Playlist> getPlaylist(int id) async {
    try {
      print('🎵 Fetching playlist $id...');
      final response = await _apiClient.get('/playlists/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final playlist = Playlist.fromJson(data);
        print('✓ Playlist $id loaded successfully');
        return playlist;
      } else {
        throw Exception('Failed to load playlist: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Playlist error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Playlist not found');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected playlist error: $e');
      throw Exception('Failed to load playlist');
    }
  }

  /// Identify song from audio file
  Future<Map<String, dynamic>> identifySong(String filePath) async {
    try {
      print('🎵 Identifying song from file: $filePath');
      
      // Check if file exists
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      // Create form data with the file
      final formData = FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(
          filePath,
          filename: 'audio_sample.${filePath.split('.').last}',
        ),
      });

      final response = await _apiClient.post(
        AppConstants.identifySongEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        print('✓ Song identified successfully');
        return data;
      } else {
        throw Exception('Failed to identify song: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Song identification error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid audio file');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Song not found in database');
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      print('❌ Unexpected song identification error: $e');
      throw Exception('Failed to identify song');
    }
  }

  /// Search for songs
  Future<List<Song>> searchSongs(String query) async {
    try {
      print('🔍 Searching for: $query');
      final response = await _apiClient.get(
        '/songs/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final songs = (data['results'] as List<dynamic>? ?? [])
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList();
        print('✓ Found ${songs.length} songs for "$query"');
        return songs;
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Search error: ${e.message}');
      throw Exception('Search failed. Please try again.');
    } catch (e) {
      print('❌ Unexpected search error: $e');
      throw Exception('Search failed');
    }
  }

  /// Get user's liked songs
  Future<List<Song>> getLikedSongs() async {
    try {
      print('❤️ Fetching liked songs...');
      final response = await _apiClient.get('/users/liked-songs');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final songs = data
            .map((e) => Song.fromJson(e as Map<String, dynamic>))
            .toList();
        print('✓ Loaded ${songs.length} liked songs');
        return songs;
      } else {
        throw Exception('Failed to load liked songs: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Liked songs error: ${e.message}');
      throw Exception('Failed to load liked songs');
    } catch (e) {
      print('❌ Unexpected liked songs error: $e');
      throw Exception('Failed to load liked songs');
    }
  }

  /// Toggle like status for a song
  Future<bool> toggleLikeSong(int songId) async {
    try {
      print('❤️ Toggling like for song $songId');
      final response = await _apiClient.post('/songs/$songId/like');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final isLiked = data['liked'] as bool? ?? false;
        print('✓ Song $songId ${isLiked ? "liked" : "unliked"}');
        return isLiked;
      } else {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Toggle like error: ${e.message}');
      throw Exception('Failed to update like status');
    } catch (e) {
      print('❌ Unexpected toggle like error: $e');
      throw Exception('Failed to update like status');
    }
  }
}