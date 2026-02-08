class EmotionSession {
  final int sessionId;
  final String emotion;
  final double confidence;
  final List<String> suggestedMoods;
  final List<Song> recommendedSongs;
  final Map<String, dynamic> analysis;
  final String createdAt;

  EmotionSession({
    required this.sessionId,
    required this.emotion,
    required this.confidence,
    required this.suggestedMoods,
    required this.recommendedSongs,
    required this.analysis,
    required this.createdAt,
  });

  factory EmotionSession.fromJson(Map<String, dynamic> json) {
    return EmotionSession(
      sessionId: json['session_id'] as int? ?? 0,
      emotion: json['emotion'] as String? ?? 'neutral',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      suggestedMoods: (json['suggested_moods'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      recommendedSongs: (json['recommended_songs'] as List<dynamic>? ?? [])
          .map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      analysis: json['analysis'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'emotion': emotion,
      'confidence': confidence,
      'suggested_moods': suggestedMoods,
      'recommended_songs': recommendedSongs.map((e) => e.toJson()).toList(),
      'analysis': analysis,
      'created_at': createdAt,
    };
  }
}

// Re-use Song class from user_feed.dart
class Song {
  final int id;
  final String title;
  final String artist;
  final String? album;
  final String? imageUrl;
  final int? duration;
  final String? previewUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.imageUrl,
    this.duration,
    this.previewUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      album: json['album'] as String?,
      imageUrl: json['image_url'] as String?,
      duration: json['duration'] as int?,
      previewUrl: json['preview_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'image_url': imageUrl,
      'duration': duration,
      'preview_url': previewUrl,
    };
  }
}