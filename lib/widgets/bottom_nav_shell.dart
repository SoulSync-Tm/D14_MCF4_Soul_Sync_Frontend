import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import 'mini_player.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({
    super.key,
    required this.child,
  });

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    switch (location) {
      case '/home':
        return 0;
      case '/scanner':
        return 1;
      case '/library':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/scanner');
        break;
      case 2:
        context.go('/library');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomSheet: const MiniPlayer(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 60), // Account for MiniPlayer height
        child: NavigationBar(
          backgroundColor: Colors.black.withOpacity(0.9),
          indicatorColor: AppTheme.primaryColor.withOpacity(0.2),
          selectedIndex: _getCurrentIndex(context),
          onDestinationSelected: (index) => _onDestinationSelected(context, index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_filled, color: Colors.white70),
              selectedIcon: Icon(Icons.home_filled, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.document_scanner_rounded, color: Colors.white70),
              selectedIcon: Icon(Icons.document_scanner_rounded, color: Colors.white),
              label: 'Vibe',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_music_rounded, color: Colors.white70),
              selectedIcon: Icon(Icons.library_music_rounded, color: Colors.white),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded, color: Colors.white70),
              selectedIcon: Icon(Icons.person_rounded, color: Colors.white),
              label: 'You',
            ),
          ],
        ),
      ),
    );
  }
}