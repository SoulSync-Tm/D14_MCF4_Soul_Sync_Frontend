import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import 'widgets/mood_chip_list_view.dart';
import 'widgets/playlist_grid_item.dart';
import 'widgets/section_header.dart';
import 'widgets/horizontal_playlist_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8A2BE2), // AppTheme.primaryColor
              Colors.black,
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Good Evening',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO: Show notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications coming soon!'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.go('/profile');
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Mood Chips
                  const MoodChipListView(),
                  const SizedBox(height: 24),
                  
                  // Jump Back In Section
                  const SectionHeader(title: 'Jump Back In'),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: [
                        PlaylistGridItem(
                          title: 'Liked Songs',
                          subtitle: '142 songs',
                          imageUrl: 'https://picsum.photos/200?random=1',
                        ),
                        PlaylistGridItem(
                          title: 'Daily Mix 1',
                          subtitle: 'Indie Rock Mix',
                          imageUrl: 'https://picsum.photos/200?random=2',
                        ),
                        PlaylistGridItem(
                          title: 'Chill Vibes',
                          subtitle: '89 songs',
                          imageUrl: 'https://picsum.photos/200?random=3',
                        ),
                        PlaylistGridItem(
                          title: 'Workout Hits',
                          subtitle: 'High Energy Mix',
                          imageUrl: 'https://picsum.photos/200?random=4',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Made For You Section
                  SectionHeader(
                    title: 'Made For You',
                    onMorePressed: () {
                      // TODO: Navigate to made for you section
                    },
                  ),
                  const SizedBox(height: 8),
                  HorizontalPlaylistList(
                    items: [
                      PlaylistItem(
                        title: 'Discover Weekly',
                        subtitle: 'New music picked for you',
                        imageUrl: 'https://picsum.photos/300?random=5',
                      ),
                      PlaylistItem(
                        title: 'Release Radar',
                        subtitle: 'Fresh releases from artists you follow',
                        imageUrl: 'https://picsum.photos/300?random=6',
                      ),
                      PlaylistItem(
                        title: 'Daily Mix 2',
                        subtitle: 'Electronic & Ambient',
                        imageUrl: 'https://picsum.photos/300?random=7',
                      ),
                      PlaylistItem(
                        title: 'Mood Booster',
                        subtitle: 'Uplifting songs to brighten your day',
                        imageUrl: 'https://picsum.photos/300?random=8',
                      ),
                      PlaylistItem(
                        title: 'Throwback Mix',
                        subtitle: 'Songs from your past favorites',
                        imageUrl: 'https://picsum.photos/300?random=9',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Popular Live Section
                  SectionHeader(
                    title: 'Popular Live',
                    onMorePressed: () {
                      // TODO: Navigate to live section
                    },
                  ),
                  const SizedBox(height: 8),
                  HorizontalPlaylistList(
                    items: [
                      PlaylistItem(
                        title: 'Live at Coachella',
                        subtitle: 'Arctic Monkeys',
                        imageUrl: 'https://picsum.photos/300?random=10',
                      ),
                      PlaylistItem(
                        title: 'Acoustic Sessions',
                        subtitle: 'Ed Sheeran',
                        imageUrl: 'https://picsum.photos/300?random=11',
                      ),
                      PlaylistItem(
                        title: 'Jazz at Lincoln Center',
                        subtitle: 'Various Artists',
                        imageUrl: 'https://picsum.photos/300?random=12',
                      ),
                      PlaylistItem(
                        title: 'MTV Unplugged',
                        subtitle: 'Classic Acoustic Sets',
                        imageUrl: 'https://picsum.photos/300?random=13',
                      ),
                      PlaylistItem(
                        title: 'Live in Concert',
                        subtitle: 'Billie Eilish',
                        imageUrl: 'https://picsum.photos/300?random=14',
                      ),
                    ],
                  ),
                  
                  // Space for MiniPlayer
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}