import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Your Library',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppTheme.primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Playlists'),
              Tab(text: 'Liked'),
              Tab(text: 'Albums'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create playlist feature coming soon!'),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            _PlaylistsTab(),
            _LikedSongsTab(),
            _AlbumsTab(),
          ],
        ),
      ),
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  const _PlaylistsTab();

  @override
  Widget build(BuildContext context) {
    final playlists = [
      {'title': 'Daily Mix 1', 'subtitle': '25 songs', 'image': 'https://picsum.photos/200?random=20'},
      {'title': 'Chill Vibes', 'subtitle': '89 songs', 'image': 'https://picsum.photos/200?random=21'},
      {'title': 'Workout Hits', 'subtitle': '156 songs', 'image': 'https://picsum.photos/200?random=22'},
      {'title': 'Study Focus', 'subtitle': '67 songs', 'image': 'https://picsum.photos/200?random=23'},
      {'title': 'Road Trip', 'subtitle': '78 songs', 'image': 'https://picsum.photos/200?random=24'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return SongTile(
          title: playlist['title']!,
          artist: playlist['subtitle']!,
          imageUrl: playlist['image']!,
        );
      },
    );
  }
}

class _LikedSongsTab extends StatelessWidget {
  const _LikedSongsTab();

  @override
  Widget build(BuildContext context) {
    final likedSongs = [
      {'title': 'Midnight City', 'artist': 'M83', 'image': 'https://picsum.photos/200?random=30'},
      {'title': 'Pumped Up Kicks', 'artist': 'Foster the People', 'image': 'https://picsum.photos/200?random=31'},
      {'title': 'Take On Me', 'artist': 'a-ha', 'image': 'https://picsum.photos/200?random=32'},
      {'title': 'Blinding Lights', 'artist': 'The Weeknd', 'image': 'https://picsum.photos/200?random=33'},
      {'title': 'Watermelon Sugar', 'artist': 'Harry Styles', 'image': 'https://picsum.photos/200?random=34'},
      {'title': 'Good 4 U', 'artist': 'Olivia Rodrigo', 'image': 'https://picsum.photos/200?random=35'},
      {'title': 'Levitating', 'artist': 'Dua Lipa', 'image': 'https://picsum.photos/200?random=36'},
      {'title': 'Peaches', 'artist': 'Justin Bieber', 'image': 'https://picsum.photos/200?random=37'},
      {'title': 'Industry Baby', 'artist': 'Lil Nas X', 'image': 'https://picsum.photos/200?random=38'},
      {'title': 'Stay', 'artist': 'The Kid LAROI, Justin Bieber', 'image': 'https://picsum.photos/200?random=39'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: likedSongs.length,
      itemBuilder: (context, index) {
        final song = likedSongs[index];
        return SongTile(
          title: song['title']!,
          artist: song['artist']!,
          imageUrl: song['image']!,
        );
      },
    );
  }
}

class _AlbumsTab extends StatelessWidget {
  const _AlbumsTab();

  @override
  Widget build(BuildContext context) {
    final albums = List.generate(12, (index) => {
      'title': 'Album ${index + 1}',
      'artist': 'Artist ${index + 1}',
      'image': 'https://picsum.photos/300?random=${40 + index}',
    });

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to album detail
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      album['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[700],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.album,
                              color: Colors.white54,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                album['title']!,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                album['artist']!,
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}