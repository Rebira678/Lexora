import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_arena/features/home/presentation/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HomeScreen loads persisted habit intention from SharedPreferences', (tester) async {
    SharedPreferences.setMockInitialValues({
      'habit_intention': '"Every evening after dinner I study 15 minutes."',
    });

    await tester.pumpWidget(
      const ProviderScope(
        overrides: [],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('"Every evening after dinner I study 15 minutes."'),
      findsOneWidget,
    );
  });
}
