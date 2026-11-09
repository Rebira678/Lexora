import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_arena/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen displays notification switch, speech slider, and privacy banner', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('100% Offline & Private'), findsOneWidget);
    expect(find.text('Daily Study Reminder'), findsOneWidget);
    expect(find.text('TTS Speech Speed'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });
}
