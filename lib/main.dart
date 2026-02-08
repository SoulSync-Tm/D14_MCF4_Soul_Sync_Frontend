import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/router.dart';
import 'core/api_client.dart';

void main() {
  // Initialize API client
  ApiClient().initialize();
  
  runApp(
    const ProviderScope(
      child: SoulSyncApp(),
    ),
  );
}

class SoulSyncApp extends StatelessWidget {
  const SoulSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SoulSync',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
