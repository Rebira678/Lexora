import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme.dart';
import 'app/router.dart';
import 'app/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ProviderContainer to execute startup migrations & content import
  final container = ProviderContainer();

  try {
    // Initialize audio & TTS services
    await container.read(audioServiceProvider).init();

    // Import content JSONs into SQLite if not already done
    final importer = container.read(contentImporterProvider);
    await importer.importIfNeeded();
  } catch (e) {
    debugPrint('Startup initialization error: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const EnglishArenaApp(),
    ),
  );
}

class EnglishArenaApp extends StatelessWidget {
  const EnglishArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'English Arena',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // Default to focused dark theme
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
