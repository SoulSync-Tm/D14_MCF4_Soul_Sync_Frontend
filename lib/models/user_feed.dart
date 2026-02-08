class UserFeed {
  final List<Playlist> playlists;
  final List<Song> recentlyPlayed;
  final List<Song> recommendations;
  final UserStats stats;

  UserFeed({
    required this.playlists,
    required this.recentlyPlayed,
    required this.recommendations,
    required this.stats,
  });

  factory UserFeed.fromJson(Map<String, dynamic> json) {
    return UserFeed(
      playlists: (json['playlists'] as List<dynamic>? ?? [])
          .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentlyPlayed: (json['recently_played'] as List<dynamic>? ?? [])
          .map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlists': playlists.map((e) => e.toJson()).toList(),
      'recently_played': recentlyPlayed.map((e) => e.toJson()).toList(),
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
}

class Playlist {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int songCount;
  final String createdAt;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.songCount,
    required this.createdAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      songCount: json['song_count'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'song_count': songCount,
      'created_at': createdAt,
    };
  }
}

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

class UserStats {
  final int totalListeningTime;
  final String topMood;
  final int playlistCount;
  final int likedSongsCount;

  UserStats({
    required this.totalListeningTime,
    required this.topMood,
    required this.playlistCount,
    required this.likedSongsCount,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalListeningTime: json['total_listening_time'] as int? ?? 0,
      topMood: json['top_mood'] as String? ?? 'Unknown',
      playlistCount: json['playlist_count'] as int? ?? 0,
      likedSongsCount: json['liked_songs_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_listening_time': totalListeningTime,
      'top_mood': topMood,
      'playlist_count': playlistCount,
      'liked_songs_count': likedSongsCount,
    };
  }
}