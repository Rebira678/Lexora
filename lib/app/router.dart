import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/games/word_siege/word_siege_screen.dart';
import '../features/games/sentence_unscrambler/sentence_unscrambler_screen.dart';
import '../features/games/vocab_sprint/vocab_sprint_screen.dart';
import '../features/games/anagram_wheel/anagram_wheel_screen.dart';
import '../features/games/paragraph_architect/paragraph_architect_screen.dart';
import '../features/games/chunk_echo/chunk_echo_screen.dart';
import '../features/games/sentence_xray/sentence_xray_screen.dart';
import '../features/reading/reading_screen.dart';
import '../features/mistakes/presentation/mistakes_screen.dart';
import '../features/stats/presentation/stats_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

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

    // 4 Phase 1 MVP Games
    GoRoute(
      path: '/games/word-siege',
      name: 'word-siege',
      builder: (context, state) => const WordSiegeScreen(level: 3),
    ),
    GoRoute(
      path: '/games/unscrambler',
      name: 'unscrambler',
      builder: (context, state) => const SentenceUnscramblerScreen(level: 1),
    ),
    GoRoute(
      path: '/games/sprint',
      name: 'sprint',
      builder: (context, state) => const VocabSprintScreen(),
    ),
    GoRoute(
      path: '/games/anagram',
      name: 'anagram',
      builder: (context, state) => const AnagramWheelScreen(),
    ),

    // Advanced & Weak-Point Games
    GoRoute(
      path: '/games/paragraph-architect',
      name: 'paragraph-architect',
      builder: (context, state) => const ParagraphArchitectScreen(level: 2),
    ),
    GoRoute(
      path: '/games/chunk-echo',
      name: 'chunk-echo',
      builder: (context, state) => const ChunkEchoScreen(level: 2),
    ),
    GoRoute(
      path: '/games/sentence-xray',
      name: 'sentence-xray',
      builder: (context, state) => const SentenceXRayScreen(level: 2),
    ),
    GoRoute(
      path: '/reading',
      name: 'reading',
      builder: (context, state) => const ReadingScreen(),
    ),

    // Navigation Hubs (Bottom Nav)
    GoRoute(
      path: '/mistakes',
      name: 'mistakes',
      builder: (context, state) => const MistakesScreen(),
    ),
    GoRoute(
      path: '/stats',
      name: 'stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
