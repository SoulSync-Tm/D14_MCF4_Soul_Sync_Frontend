import 'package:go_router/go_router.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scanner/vibe_check_screen.dart';
import '../screens/scanner/music_detect_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/landing_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Landing/Splash Screen
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      
      // Authentication Screen
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Home Screen
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Scanner/Vibe Check Screen
      GoRoute(
        path: '/scanner',
        name: 'scanner',
        builder: (context, state) => const VibeCheckScreen(),
      ),
      
      // Music Detection Screen
      GoRoute(
        path: '/music-detect',
        name: 'musicDetect',
        builder: (context, state) => const MusicDetectScreen(),
      ),
      
      // Library Screen
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
      ),
      
      // Player Screen
      GoRoute(
        path: '/player',
        name: 'player',
        builder: (context, state) => const PlayerScreen(),
      ),
    ],
  );
}