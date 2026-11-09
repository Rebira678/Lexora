import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_arena/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders AppBar, Body, and BottomNav at bottom', (tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    // Check that LEXORA text is found (AppBar)
    expect(find.text('LEXORA'), findsOneWidget);
    // Check that Word Siege is found (Body)
    expect(find.text('Word Siege'), findsOneWidget);
    
    // Check bottom nav bar position
    final navFinder = find.byType(NavigationBar);
    expect(navFinder, findsOneWidget);
    final navBox = tester.getRect(navFinder);
    // NavBox should be at the bottom (around y = 1080 - 64 = 1016), NOT at y = 500!
    expect(navBox.top, greaterThan(900));
  });
}
