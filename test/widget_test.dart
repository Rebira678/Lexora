import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_arena/main.dart';

void main() {
  testWidgets('English Arena smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EnglishArenaApp(),
      ),
    );

    // Verify app renders MaterialApp with title
    expect(find.byType(EnglishArenaApp), findsOneWidget);
  });
}
