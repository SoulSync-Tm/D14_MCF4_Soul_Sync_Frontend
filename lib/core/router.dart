import 'package:go_router/go_router.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/scanner/vibe_check_screen.dart';
import '../screens/scanner/music_detect_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/landing_screen.dart';
import '../widgets/bottom_nav_shell.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Landing/Splash Screen (Full screen)
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      
      // Authentication Screen (Full screen)
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Music Detection Screen (Full screen)
      GoRoute(
        path: '/music-detect',
        name: 'musicDetect',
        builder: (context, state) => const MusicDetectScreen(),
      ),
      
      // Player Screen (Full screen)
      GoRoute(
        path: '/player',
        name: 'player',
        builder: (context, state) => const PlayerScreen(),
      ),
      
      // Shell Route for persistent navigation
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
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
          
          // Library Screen
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) => const LibraryScreen(),
          ),
          
          // Profile Screen
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}