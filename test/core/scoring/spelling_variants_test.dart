import 'package:flutter_test/flutter_test.dart';
import 'package:english_arena/core/scoring/scoring.dart';

void main() {
  group('Word Siege Spelling & US/UK Variants Acceptance Tests', () {
    test('Accepts exact matches case-insensitively with whitespace', () {
      expect(isAnswerOk('reluctant', 'reluctant'), isTrue);
      expect(isAnswerOk('  RELUCTANT  ', 'reluctant'), isTrue);
      expect(isAnswerOk('Reluctant', 'RELUCTANT'), isTrue);
    });

    test('Accepts US/UK spelling variants automatically (-our vs -or)', () {
      expect(isAnswerOk('colour', 'color'), isTrue);
      expect(isAnswerOk('color', 'colour'), isTrue);
      expect(isAnswerOk('favour', 'favor'), isTrue);
      expect(isAnswerOk('honor', 'honour'), isTrue);
      expect(isAnswerOk('rumour', 'rumor'), isTrue);
    });

    test('Accepts US/UK spelling variants (-ise vs -ize)', () {
      expect(isAnswerOk('realise', 'realize'), isTrue);
      expect(isAnswerOk('realize', 'realise'), isTrue);
      expect(isAnswerOk('organise', 'organize'), isTrue);
      expect(isAnswerOk('criticise', 'criticize'), isTrue);
    });

    test('Accepts US/UK spelling variants (-re vs -er)', () {
      expect(isAnswerOk('theatre', 'theater'), isTrue);
      expect(isAnswerOk('center', 'centre'), isTrue);
      expect(isAnswerOk('metre', 'meter'), isTrue);
      expect(isAnswerOk('litre', 'liter'), isTrue);
    });

    test('Accepts US/UK spelling variants (-ence vs -ense)', () {
      expect(isAnswerOk('defence', 'defense'), isTrue);
      expect(isAnswerOk('license', 'licence'), isTrue);
      expect(isAnswerOk('offence', 'offense'), isTrue);
    });

    test('Accepts US/UK spelling variants (-ogue vs -og)', () {
      expect(isAnswerOk('dialogue', 'dialog'), isTrue);
      expect(isAnswerOk('catalog', 'catalogue'), isTrue);
    });

    test('Accepts explicit alternative accepted variants list', () {
      expect(
        isAnswerOk(
          'quick',
          'fast',
          acceptedVariants: ['swift', 'quick', 'rapid'],
        ),
        isTrue,
      );
      expect(
        isAnswerOk(
          'swift',
          'fast',
          acceptedVariants: ['swift', 'quick', 'rapid'],
        ),
        isTrue,
      );
    });

    test('Tolerance rule: Level 1-3 allows 1 typo, Level 5-6 requires exact spelling', () {
      // 1-letter typo on long word
      expect(isAnswerOk('reluctent', 'reluctant', tolerance: 1), isTrue);
      // Strict tolerance (level 5-6) rejects even 1-letter typo
      expect(isAnswerOk('reluctent', 'reluctant', tolerance: 0), isFalse);
      expect(isAnswerOk('reluctant', 'reluctant', tolerance: 0), isTrue);
    });
  });
}
