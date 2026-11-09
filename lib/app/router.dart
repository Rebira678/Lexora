import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_screen.dart';

/// App router using GoRouter — declarative, type-safe routing.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home / Dashboard
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Placeholder routes — will be implemented in Phase 1+
    // GoRoute(path: '/games/anagram', name: 'anagram', ...),
    // GoRoute(path: '/games/unscrambler', name: 'unscrambler', ...),
    // GoRoute(path: '/games/sprint', name: 'sprint', ...),
    // GoRoute(path: '/games/word-siege', name: 'word-siege', ...),
    // GoRoute(path: '/games/paragraph-architect', name: 'paragraph-architect', ...),
    // GoRoute(path: '/games/chunk-echo', name: 'chunk-echo', ...),
    // GoRoute(path: '/stats', name: 'stats', ...),
    // GoRoute(path: '/mistakes', name: 'mistakes', ...),
    // GoRoute(path: '/settings', name: 'settings', ...),
  ],
);
