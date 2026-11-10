import 'dart:math';
import 'package:flutter/material.dart';

/// Procedural vector art illustrations for each game module.
/// 100% offline, resolution-independent, zero asset loading time.

enum GameArtType {
  wordSiege,
  vocabSprint,
  unscrambler,
  anagramWheel,
  paragraphArchitect,
  chunkEcho,
  sentenceXray,
  sliceIt,
  connectorMatch,
  layerBuilder,
  contextDetective,
  prefixSuffix,
  wordFamilyTree,
  dictationDash,
  soundSniper,
  errorHunter,
  gradedReader,
  collocationMatch,
  wordForge,
  dailyJournal,
  sixtySecondTalker,
  shadowBoxing,
  bossBattle,
  mockTest,
  achievements,
  rolePlay,
  storyBranch,
  phrasalDungeon,
  idiomEscape,
  emailBoss,
  customDecks,
  nuanceDuel,
  registerShifter,
  paraphraseBlitz,
  collocationForge,
  lectureNotes,
  debateMode,
  cohesionFixer,
  realEnglishLog,
  styleAnalyzer,
  c2LongReader,
  linguisticEvaluator,
  gapFinder,
}

class GameArtWidget extends StatelessWidget {
  final GameArtType type;
  final Color primaryColor;
  final double height;

  const GameArtWidget({
    super.key,
    required this.type,
    this.primaryColor = const Color(0xFF6366F1),
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        child: CustomPaint(
          painter: _GameArtPainter(
            type: type,
            primaryColor: primaryColor,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
        ),
      ),
    );
  }
}

class _GameArtPainter extends CustomPainter {
  final GameArtType type;
  final Color primaryColor;
  final bool isDark;

  _GameArtPainter({
    required this.type,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background ambient gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                primaryColor.withAlpha(45),
                const Color(0xFF131622),
              ]
            : [
                primaryColor.withAlpha(25),
                const Color(0xFFF1F3F9),
              ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle background grid / dots
    final dotPaint = Paint()
      ..color = primaryColor.withAlpha(isDark ? 20 : 15)
      ..style = PaintingStyle.fill;

    for (double x = 16; x < size.width; x += 24) {
      for (double y = 16; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }

    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case GameArtType.wordSiege:
        _drawWordSiegeArt(canvas, size, center);
        break;
      case GameArtType.vocabSprint:
        _drawVocabSprintArt(canvas, size, center);
        break;
      case GameArtType.unscrambler:
        _drawUnscramblerArt(canvas, size, center);
        break;
      case GameArtType.anagramWheel:
        _drawAnagramWheelArt(canvas, size, center);
        break;
      case GameArtType.paragraphArchitect:
        _drawParagraphArchitectArt(canvas, size, center);
        break;
      case GameArtType.chunkEcho:
        _drawChunkEchoArt(canvas, size, center);
        break;
      case GameArtType.sentenceXray:
        _drawSentenceXrayArt(canvas, size, center);
        break;
      case GameArtType.sliceIt:
        _drawSliceItArt(canvas, size, center);
        break;
      case GameArtType.connectorMatch:
        _drawConnectorMatchArt(canvas, size, center);
        break;
      case GameArtType.layerBuilder:
        _drawLayerBuilderArt(canvas, size, center);
        break;
      case GameArtType.contextDetective:
        _drawContextDetectiveArt(canvas, size, center);
        break;
      case GameArtType.prefixSuffix:
        _drawPrefixSuffixArt(canvas, size, center);
        break;
      case GameArtType.wordFamilyTree:
        _drawWordFamilyTreeArt(canvas, size, center);
        break;
      case GameArtType.dictationDash:
        _drawDictationDashArt(canvas, size, center);
        break;
      case GameArtType.soundSniper:
        _drawSoundSniperArt(canvas, size, center);
        break;
      case GameArtType.errorHunter:
        _drawErrorHunterArt(canvas, size, center);
        break;
      case GameArtType.gradedReader:
        _drawGradedReaderArt(canvas, size, center);
        break;
      case GameArtType.collocationMatch:
        _drawCollocationMatchArt(canvas, size, center);
        break;
      case GameArtType.wordForge:
        _drawWordForgeArt(canvas, size, center);
        break;
      case GameArtType.dailyJournal:
        _drawDailyJournalArt(canvas, size, center);
        break;
      case GameArtType.sixtySecondTalker:
        _drawSixtySecondTalkerArt(canvas, size, center);
        break;
      case GameArtType.shadowBoxing:
        _drawShadowBoxingArt(canvas, size, center);
        break;
      case GameArtType.bossBattle:
        _drawBossBattleArt(canvas, size, center);
        break;
      case GameArtType.mockTest:
        _drawMockTestArt(canvas, size, center);
        break;
      case GameArtType.achievements:
        _drawAchievementsArt(canvas, size, center);
        break;
      case GameArtType.rolePlay:
        _drawRolePlayArt(canvas, size, center);
        break;
      case GameArtType.storyBranch:
        _drawStoryBranchArt(canvas, size, center);
        break;
      case GameArtType.phrasalDungeon:
        _drawPhrasalDungeonArt(canvas, size, center);
        break;
      case GameArtType.idiomEscape:
        _drawIdiomEscapeArt(canvas, size, center);
        break;
      case GameArtType.emailBoss:
        _drawEmailBossArt(canvas, size, center);
        break;
      case GameArtType.customDecks:
        _drawCustomDecksArt(canvas, size, center);
        break;
      case GameArtType.nuanceDuel:
        _drawNuanceDuelArt(canvas, size, center);
        break;
      case GameArtType.registerShifter:
        _drawRegisterShifterArt(canvas, size, center);
        break;
      case GameArtType.paraphraseBlitz:
        _drawParaphraseBlitzArt(canvas, size, center);
        break;
      case GameArtType.collocationForge:
        _drawCollocationForgeArt(canvas, size, center);
        break;
      case GameArtType.lectureNotes:
        _drawLectureNotesArt(canvas, size, center);
        break;
      case GameArtType.debateMode:
        _drawDebateModeArt(canvas, size, center);
        break;
      case GameArtType.cohesionFixer:
        _drawCohesionFixerArt(canvas, size, center);
        break;
      case GameArtType.realEnglishLog:
        _drawRealEnglishLogArt(canvas, size, center);
        break;
      case GameArtType.styleAnalyzer:
        _drawStyleAnalyzerArt(canvas, size, center);
        break;
      case GameArtType.c2LongReader:
        _drawC2LongReaderArt(canvas, size, center);
        break;
      case GameArtType.linguisticEvaluator:
        _drawLinguisticEvaluatorArt(canvas, size, center);
        break;
      case GameArtType.gapFinder:
        _drawGapFinderArt(canvas, size, center);
        break;
    }
  }

  /// ⚔️ Word Siege: Modern tactical shield & defense gate
  void _drawWordSiegeArt(Canvas canvas, Size size, Offset center) {
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = primaryColor.withAlpha(30)
      ..style = PaintingStyle.fill;

    // Glowing shield outline
    final shieldPath = Path();
    const w = 24.0;
    const h = 30.0;
    shieldPath.moveTo(center.dx - w, center.dy - h * 0.6);
    shieldPath.lineTo(center.dx + w, center.dy - h * 0.6);
    shieldPath.lineTo(center.dx + w, center.dy);
    shieldPath.quadraticBezierTo(center.dx + w, center.dy + h * 0.7, center.dx, center.dy + h);
    shieldPath.quadraticBezierTo(center.dx - w, center.dy + h * 0.7, center.dx - w, center.dy);
    shieldPath.close();

    canvas.drawPath(shieldPath, fillPaint);
    canvas.drawPath(shieldPath, strokePaint);

    // Fortress battlement lines
    final gatePaint = Paint()
      ..color = primaryColor.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Defense grid lines radiating
    canvas.drawLine(
      Offset(center.dx - w * 1.6, center.dy + h * 0.3),
      Offset(center.dx + w * 1.6, center.dy + h * 0.3),
      gatePaint,
    );
    canvas.drawLine(
      Offset(center.dx - w * 1.2, center.dy + h * 0.6),
      Offset(center.dx + w * 1.2, center.dy + h * 0.6),
      gatePaint,
    );

    // Inner glowing core
    canvas.drawCircle(Offset(center.dx, center.dy), 5.0, Paint()..color = primaryColor);
  }

  /// ⚡ Vocab Sprint: Kinetic speed curves & velocity flash
  void _drawVocabSprintArt(Canvas canvas, Size size, Offset center) {
    final boltPath = Path();
    boltPath.moveTo(center.dx + 4, center.dy - 28);
    boltPath.lineTo(center.dx - 14, center.dy - 2);
    boltPath.lineTo(center.dx - 2, center.dy - 2);
    boltPath.lineTo(center.dx - 6, center.dy + 26);
    boltPath.lineTo(center.dx + 16, center.dy - 4);
    boltPath.lineTo(center.dx + 4, center.dy - 4);
    boltPath.close();

    final fillPaint = Paint()
      ..color = primaryColor.withAlpha(40)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(boltPath, fillPaint);
    canvas.drawPath(boltPath, strokePaint);

    // Kinetic speed horizontal streaks
    final streakPaint = Paint()
      ..color = primaryColor.withAlpha(120)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(center.dx - 40, center.dy - 12), Offset(center.dx - 22, center.dy - 12), streakPaint);
    canvas.drawLine(Offset(center.dx + 22, center.dy + 10), Offset(center.dx + 42, center.dy + 10), streakPaint);
    canvas.drawLine(Offset(center.dx - 32, center.dy + 18), Offset(center.dx - 18, center.dy + 18), streakPaint);
  }

  /// 🧱 Sentence Unscrambler: Interlocking isometric syntax tiles
  void _drawUnscramblerArt(Canvas canvas, Size size, Offset center) {
    final tilePaint = Paint()
      ..color = primaryColor.withAlpha(35)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Tile 1
    final r1 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 20, center.dy - 10), width: 38, height: 22),
      const Radius.circular(5),
    );
    canvas.drawRRect(r1, tilePaint);
    canvas.drawRRect(r1, strokePaint);

    // Tile 2 (interlocking)
    final r2 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 22, center.dy - 6), width: 44, height: 22),
      const Radius.circular(5),
    );
    canvas.drawRRect(r2, tilePaint);
    canvas.drawRRect(r2, strokePaint);

    // Tile 3 (base)
    final r3 = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 2, center.dy + 16), width: 52, height: 20),
      const Radius.circular(5),
    );
    canvas.drawRRect(r3, Paint()..color = primaryColor.withAlpha(60));
    canvas.drawRRect(r3, strokePaint);

    // Connection indicator dots
    final dotPaint = Paint()..color = primaryColor;
    canvas.drawCircle(Offset(center.dx - 20, center.dy - 10), 2.5, dotPaint);
    canvas.drawCircle(Offset(center.dx + 22, center.dy - 6), 2.5, dotPaint);
    canvas.drawCircle(Offset(center.dx - 2, center.dy + 16), 2.5, dotPaint);
  }

  /// 🎡 Anagram Wheel: Concentric celestial cipher wheel
  void _drawAnagramWheelArt(Canvas canvas, Size size, Offset center) {
    final ringPaint = Paint()
      ..color = primaryColor.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, 28, ringPaint);
    canvas.drawCircle(center, 14, ringPaint);

    // Radial spokes & node dots
    final spokePaint = Paint()
      ..color = primaryColor.withAlpha(140)
      ..strokeWidth = 1.2;

    const count = 6;
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i;
      final x = center.dx + 28 * cos(angle);
      final y = center.dy + 28 * sin(angle);
      canvas.drawLine(center, Offset(x, y), spokePaint);
      canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = primaryColor);
    }

    // Center pivot
    canvas.drawCircle(center, 5.0, Paint()..color = primaryColor);
  }

  /// 📑 Paragraph Architect: Blueprint structure with connecting nodes
  void _drawParagraphArchitectArt(Canvas canvas, Size size, Offset center) {
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final boxPaint = Paint()
      ..color = primaryColor.withAlpha(35)
      ..style = PaintingStyle.fill;

    // 3 blueprint horizontal blocks
    for (int i = 0; i < 3; i++) {
      final y = center.dy - 20 + i * 20;
      final w = (i == 1) ? 56.0 : 42.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, y), width: w, height: 12),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, boxPaint);
      canvas.drawRRect(rect, linePaint);
    }

    // Connecting vertical arrow line
    final connPaint = Paint()
      ..color = primaryColor.withAlpha(160)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(center.dx - 32, center.dy - 16), Offset(center.dx - 32, center.dy + 16), connPaint);
    canvas.drawCircle(Offset(center.dx - 32, center.dy - 16), 2.5, Paint()..color = primaryColor);
    canvas.drawCircle(Offset(center.dx - 32, center.dy + 16), 2.5, Paint()..color = primaryColor);
  }

  /// 🔊 Chunk Echo: Equalizer spectrum & acoustic waveform
  void _drawChunkEchoArt(Canvas canvas, Size size, Offset center) {
    final barPaint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    final heights = [8.0, 16.0, 26.0, 36.0, 24.0, 32.0, 18.0, 10.0];
    const spacing = 7.0;
    final startX = center.dx - (heights.length * spacing) / 2;

    for (int i = 0; i < heights.length; i++) {
      final x = startX + i * spacing;
      final h = heights[i];
      canvas.drawLine(
        Offset(x, center.dy - h / 2),
        Offset(x, center.dy + h / 2),
        barPaint..color = primaryColor.withAlpha(i % 2 == 0 ? 255 : 160),
      );
    }

    // Wave ring
    canvas.drawCircle(
      center,
      30,
      Paint()
        ..color = primaryColor.withAlpha(30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  /// 🔬 Sentence X-Ray: Grammatical scanning radar
  void _drawSentenceXrayArt(Canvas canvas, Size size, Offset center) {
    final ringPaint = Paint()
      ..color = primaryColor.withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, 26, ringPaint);
    canvas.drawCircle(center, 12, ringPaint);

    // Crosshairs
    final linePaint = Paint()
      ..color = primaryColor.withAlpha(120)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(center.dx - 34, center.dy), Offset(center.dx + 34, center.dy), linePaint);
    canvas.drawLine(Offset(center.dx, center.dy - 34), Offset(center.dx, center.dy + 34), linePaint);

    // Core focus dot
    canvas.drawCircle(center, 4, Paint()..color = primaryColor);
  }

  /// ✂️ Slice It: Sentence chunk blocks with precision divider laser cuts
  void _drawSliceItArt(Canvas canvas, Size size, Offset center) {
    final blockPaint = Paint()
      ..color = primaryColor.withAlpha(40)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = primaryColor.withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final laserCutPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Segment 1 (Left block)
    final r1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 42, center.dy - 12, 34, 24),
      const Radius.circular(6),
    );
    canvas.drawRRect(r1, blockPaint);
    canvas.drawRRect(r1, borderPaint);

    // Segment 2 (Right block)
    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx + 8, center.dy - 12, 34, 24),
      const Radius.circular(6),
    );
    canvas.drawRRect(r2, blockPaint);
    canvas.drawRRect(r2, borderPaint);

    // Vertical neon cut line between segments
    canvas.drawLine(
      Offset(center.dx - 4, center.dy - 18),
      Offset(center.dx - 4, center.dy + 18),
      laserCutPaint,
    );

    // Subtle scissor notch indicators
    final notchPaint = Paint()
      ..color = primaryColor.withAlpha(220)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawLine(Offset(center.dx - 8, center.dy - 16), Offset(center.dx - 4, center.dy - 12), notchPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 16), Offset(center.dx - 4, center.dy - 12), notchPaint);
  }

  /// 🔗 Connector Match: Bidirectional discourse bridge
  void _drawConnectorMatchArt(Canvas canvas, Size size, Offset center) {
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = primaryColor.withAlpha(40)
      ..style = PaintingStyle.fill;

    // Left Node
    canvas.drawCircle(Offset(center.dx - 26, center.dy), 10, fillPaint);
    canvas.drawCircle(Offset(center.dx - 26, center.dy), 10, strokePaint);

    // Right Node
    canvas.drawCircle(Offset(center.dx + 26, center.dy), 10, fillPaint);
    canvas.drawCircle(Offset(center.dx + 26, center.dy), 10, strokePaint);

    // Double bridge connector line
    canvas.drawLine(Offset(center.dx - 16, center.dy - 3), Offset(center.dx + 16, center.dy - 3), strokePaint);
    canvas.drawLine(Offset(center.dx - 16, center.dy + 3), Offset(center.dx + 16, center.dy + 3), strokePaint);

    // Center jewel node
    canvas.drawCircle(center, 5, Paint()..color = primaryColor);
  }

  /// 🏗️ Layer Builder: Isometric architectural steps
  void _drawLayerBuilderArt(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = primaryColor.withAlpha(45)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Foundation Base
    final r1 = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - 34, center.dy + 8, 68, 14), const Radius.circular(4));
    canvas.drawRRect(r1, paint);
    canvas.drawRRect(r1, stroke);

    // Second Layer
    final r2 = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - 24, center.dy - 6, 48, 14), const Radius.circular(4));
    canvas.drawRRect(r2, paint);
    canvas.drawRRect(r2, stroke);

    // Top Layer
    final r3 = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - 14, center.dy - 20, 28, 14), const Radius.circular(4));
    canvas.drawRRect(r3, Paint()..color = primaryColor.withAlpha(80));
    canvas.drawRRect(r3, stroke);
  }

  /// 🔍 Context Detective: Forensic lens targeting text clues
  void _drawContextDetectiveArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final fill = Paint()
      ..color = primaryColor.withAlpha(35)
      ..style = PaintingStyle.fill;

    // Magnifying lens
    final lensCenter = Offset(center.dx - 4, center.dy - 4);
    canvas.drawCircle(lensCenter, 18, fill);
    canvas.drawCircle(lensCenter, 18, stroke);

    // Handle
    final handlePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(lensCenter.dx + 13, lensCenter.dy + 13), Offset(center.dx + 28, center.dy + 28), handlePaint);

    // Target text line inside lens
    final linePaint = Paint()
      ..color = primaryColor.withAlpha(200)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(lensCenter.dx - 10, lensCenter.dy - 3), Offset(lensCenter.dx + 10, lensCenter.dy - 3), linePaint);
    canvas.drawLine(Offset(lensCenter.dx - 6, lensCenter.dy + 4), Offset(lensCenter.dx + 6, lensCenter.dy + 4), linePaint);
  }

  /// 🧪 Prefix & Suffix Lab: Molecular morphology interlocking tiles
  void _drawPrefixSuffixArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final fill = Paint()
      ..color = primaryColor.withAlpha(40)
      ..style = PaintingStyle.fill;

    // Prefix block
    final pR = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - 38, center.dy - 12, 22, 24), const Radius.circular(5));
    canvas.drawRRect(pR, fill);
    canvas.drawRRect(pR, stroke);

    // Core Root block
    final cR = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - 12, center.dy - 15, 24, 30), const Radius.circular(5));
    canvas.drawRRect(cR, Paint()..color = primaryColor.withAlpha(70));
    canvas.drawRRect(cR, stroke);

    // Suffix block
    final sR = RRect.fromRectAndRadius(Rect.fromLTWH(center.dx + 16, center.dy - 12, 22, 24), const Radius.circular(5));
    canvas.drawRRect(sR, fill);
    canvas.drawRRect(sR, stroke);

    // Connection pulses
    canvas.drawCircle(Offset(center.dx - 14, center.dy), 2.5, Paint()..color = primaryColor);
    canvas.drawCircle(Offset(center.dx + 14, center.dy), 2.5, Paint()..color = primaryColor);
  }

  /// 🌳 Word Family Tree: Minimalist morphological hierarchy
  void _drawWordFamilyTreeArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final nodePaint = Paint()
      ..color = primaryColor.withAlpha(60)
      ..style = PaintingStyle.fill;

    final rootPos = Offset(center.dx, center.dy - 16);
    final leftPos = Offset(center.dx - 26, center.dy + 16);
    final midPos = Offset(center.dx, center.dy + 18);
    final rightPos = Offset(center.dx + 26, center.dy + 16);

    // Tree branches
    canvas.drawLine(rootPos, leftPos, stroke);
    canvas.drawLine(rootPos, midPos, stroke);
    canvas.drawLine(rootPos, rightPos, stroke);

    // Root bud
    canvas.drawCircle(rootPos, 9, Paint()..color = primaryColor);

    // Branch leaves
    canvas.drawCircle(leftPos, 6, nodePaint);
    canvas.drawCircle(leftPos, 6, stroke);
    canvas.drawCircle(midPos, 6, nodePaint);
    canvas.drawCircle(midPos, 6, stroke);
    canvas.drawCircle(rightPos, 6, nodePaint);
    canvas.drawCircle(rightPos, 6, stroke);
  }

  /// 🎧 Dictation Dash: Audio waveform and keyboard transcription cursor
  void _drawDictationDashArt(Canvas canvas, Size size, Offset center) {
    final wavePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Waveform bars
    const heights = [6.0, 16.0, 26.0, 14.0, 28.0, 18.0, 8.0];
    for (int i = 0; i < heights.length; i++) {
      final x = center.dx - 30 + (i * 10);
      final h = heights[i];
      canvas.drawLine(Offset(x, center.dy - 6 - h / 2), Offset(x, center.dy - 6 + h / 2), wavePaint);
    }

    // Underline and cursor below
    final linePaint = Paint()
      ..color = primaryColor.withAlpha(140)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(center.dx - 32, center.dy + 20), Offset(center.dx + 16, center.dy + 20), linePaint);
    // Cursor
    canvas.drawLine(Offset(center.dx + 20, center.dy + 14), Offset(center.dx + 20, center.dy + 24), wavePaint);
  }

  /// 🎯 Sound Sniper: Precision auditory minimal-pairs crosshair
  void _drawSoundSniperArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    // Dual target reticles
    canvas.drawCircle(center, 22, stroke);
    canvas.drawCircle(center, 12, stroke);

    // Crosshair axes
    canvas.drawLine(Offset(center.dx - 28, center.dy), Offset(center.dx - 14, center.dy), stroke);
    canvas.drawLine(Offset(center.dx + 14, center.dy), Offset(center.dx + 28, center.dy), stroke);
    canvas.drawLine(Offset(center.dx, center.dy - 28), Offset(center.dx, center.dy - 14), stroke);
    canvas.drawLine(Offset(center.dx, center.dy + 14), Offset(center.dx, center.dy + 28), stroke);

    // Bullseye point
    canvas.drawCircle(center, 3.5, Paint()..color = primaryColor);
  }

  /// 🦅 Error Hunter: Precision scanning lens with capture brackets
  void _drawErrorHunterArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const s = 18.0;
    // Top-left bracket
    canvas.drawLine(Offset(center.dx - s, center.dy - s + 8), Offset(center.dx - s, center.dy - s), stroke);
    canvas.drawLine(Offset(center.dx - s, center.dy - s), Offset(center.dx - s + 8, center.dy - s), stroke);

    // Top-right bracket
    canvas.drawLine(Offset(center.dx + s - 8, center.dy - s), Offset(center.dx + s, center.dy - s), stroke);
    canvas.drawLine(Offset(center.dx + s, center.dy - s), Offset(center.dx + s, center.dy - s + 8), stroke);

    // Bottom-left bracket
    canvas.drawLine(Offset(center.dx - s, center.dy + s - 8), Offset(center.dx - s, center.dy + s), stroke);
    canvas.drawLine(Offset(center.dx - s, center.dy + s), Offset(center.dx - s + 8, center.dy + s), stroke);

    // Bottom-right bracket
    canvas.drawLine(Offset(center.dx + s - 8, center.dy + s), Offset(center.dx + s, center.dy + s), stroke);
    canvas.drawLine(Offset(center.dx + s, center.dy + s), Offset(center.dx + s, center.dy + s - 8), stroke);

    // Center warning capture dot
    canvas.drawCircle(center, 4, Paint()..color = primaryColor);
  }

  /// 📖 Graded Reader: Open illuminated book
  void _drawGradedReaderArt(Canvas canvas, Size size, Offset center) {
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final fillPaint = Paint()
      ..color = primaryColor.withAlpha(35)
      ..style = PaintingStyle.fill;

    // Open book pages
    final leftPage = Path()
      ..moveTo(center.dx, center.dy + 18)
      ..lineTo(center.dx - 28, center.dy + 14)
      ..lineTo(center.dx - 28, center.dy - 16)
      ..quadraticBezierTo(center.dx - 14, center.dy - 12, center.dx, center.dy - 18)
      ..close();

    final rightPage = Path()
      ..moveTo(center.dx, center.dy + 18)
      ..lineTo(center.dx + 28, center.dy + 14)
      ..lineTo(center.dx + 28, center.dy - 16)
      ..quadraticBezierTo(center.dx + 14, center.dy - 12, center.dx, center.dy - 18)
      ..close();

    canvas.drawPath(leftPage, fillPaint);
    canvas.drawPath(leftPage, strokePaint);
    canvas.drawPath(rightPage, fillPaint);
    canvas.drawPath(rightPage, strokePaint);

    // Bookmark ribbon
    final ribbonPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(center.dx, center.dy - 18), Offset(center.dx, center.dy + 22), ribbonPaint);
  }

  /// 🔗 Collocation Match: Interlocking semantic rings
  void _drawCollocationMatchArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx - 12, center.dy), width: 34, height: 22),
        const Radius.circular(11),
      ),
      stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + 12, center.dy), width: 34, height: 22),
        const Radius.circular(11),
      ),
      stroke,
    );
  }

  /// ✍️ Word Forge: Anvil and rising sparks
  void _drawWordForgeArt(Canvas canvas, Size size, Offset center) {
    final fill = Paint()..color = primaryColor.withAlpha(40);
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final anvil = Path()
      ..moveTo(center.dx - 24, center.dy - 6)
      ..lineTo(center.dx + 24, center.dy - 6)
      ..lineTo(center.dx + 16, center.dy + 4)
      ..lineTo(center.dx + 10, center.dy + 4)
      ..lineTo(center.dx + 14, center.dy + 16)
      ..lineTo(center.dx - 14, center.dy + 16)
      ..lineTo(center.dx - 10, center.dy + 4)
      ..lineTo(center.dx - 16, center.dy + 4)
      ..close();

    canvas.drawPath(anvil, fill);
    canvas.drawPath(anvil, stroke);

    // Sparks
    final spark = Paint()..color = primaryColor..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 8, center.dy - 14), 2.0, spark);
    canvas.drawCircle(Offset(center.dx + 4, center.dy - 18), 2.5, spark);
    canvas.drawCircle(Offset(center.dx + 14, center.dy - 12), 1.5, spark);
  }

  /// 📓 Daily Journal: Ruled notebook with pen
  void _drawDailyJournalArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final page = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 44, height: 48),
      const Radius.circular(6),
    );
    canvas.drawRRect(page, Paint()..color = primaryColor.withAlpha(30));
    canvas.drawRRect(page, stroke);

    // 3 lines
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(
        Offset(center.dx - 14, center.dy + (i * 9)),
        Offset(center.dx + 14, center.dy + (i * 9)),
        stroke,
      );
    }
  }

  /// 🗣️ 60-Second Talker: Studio mic inside a running timer arc
  void _drawSixtySecondTalkerArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Timer outer arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 26),
      -pi / 2,
      1.6 * pi,
      false,
      stroke,
    );

    // Mic capsule
    final mic = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 3), width: 14, height: 22),
      const Radius.circular(7),
    );
    canvas.drawRRect(mic, Paint()..color = primaryColor.withAlpha(40));
    canvas.drawRRect(mic, stroke);

    // Mic stand
    canvas.drawLine(Offset(center.dx, center.dy + 8), Offset(center.dx, center.dy + 17), stroke);
    canvas.drawLine(Offset(center.dx - 8, center.dy + 17), Offset(center.dx + 8, center.dy + 17), stroke);
  }

  /// 🥊 Shadow Boxing: Twin overlapping acoustic sound waves
  void _drawShadowBoxingArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Wave A
    final wave1 = Path()
      ..moveTo(center.dx - 28, center.dy - 4)
      ..quadraticBezierTo(center.dx - 14, center.dy - 20, center.dx, center.dy - 4)
      ..quadraticBezierTo(center.dx + 14, center.dy + 12, center.dx + 28, center.dy - 4);
    canvas.drawPath(wave1, stroke);

    // Wave B (Shadow)
    final strokeGhost = Paint()
      ..color = primaryColor.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final wave2 = Path()
      ..moveTo(center.dx - 28, center.dy + 6)
      ..quadraticBezierTo(center.dx - 14, center.dy - 10, center.dx, center.dy + 6)
      ..quadraticBezierTo(center.dx + 14, center.dy + 22, center.dx + 28, center.dy + 6);
    canvas.drawPath(wave2, strokeGhost);
  }

  /// ⚔️ Weekly Boss: Twin crossed blades with crowned skull/helm
  void _drawBossBattleArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Crossed blades
    canvas.drawLine(Offset(center.dx - 22, center.dy - 18), Offset(center.dx + 22, center.dy + 18), stroke);
    canvas.drawLine(Offset(center.dx + 22, center.dy - 18), Offset(center.dx - 22, center.dy + 18), stroke);

    // Boss Crown / Shield
    final crown = Path()
      ..moveTo(center.dx - 12, center.dy + 8)
      ..lineTo(center.dx - 14, center.dy - 8)
      ..lineTo(center.dx - 6, center.dy - 2)
      ..lineTo(center.dx, center.dy - 12)
      ..lineTo(center.dx + 6, center.dy - 2)
      ..lineTo(center.dx + 14, center.dy - 8)
      ..lineTo(center.dx + 12, center.dy + 8)
      ..close();

    canvas.drawPath(crown, Paint()..color = primaryColor.withAlpha(40));
    canvas.drawPath(crown, stroke);
  }

  /// 📊 Mock Test: Diagnostic exam sheet with seal
  void _drawMockTestArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final sheet = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 40, height: 48),
      const Radius.circular(6),
    );
    canvas.drawRRect(sheet, Paint()..color = primaryColor.withAlpha(30));
    canvas.drawRRect(sheet, stroke);

    // Checklist lines
    canvas.drawLine(Offset(center.dx - 12, center.dy - 12), Offset(center.dx + 12, center.dy - 12), stroke);
    canvas.drawLine(Offset(center.dx - 12, center.dy - 4), Offset(center.dx + 12, center.dy - 4), stroke);
    canvas.drawLine(Offset(center.dx - 12, center.dy + 4), Offset(center.dx + 4, center.dy + 4), stroke);

    // Star seal
    canvas.drawCircle(Offset(center.dx + 8, center.dy + 12), 4.5, Paint()..color = primaryColor);
  }

  /// 🏆 Achievements: Laurel wreath and center star
  void _drawAchievementsArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Laurel branches
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx - 6, center.dy), radius: 18),
      pi * 0.4,
      pi * 1.2,
      false,
      stroke,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx + 6, center.dy), radius: 18),
      -pi * 0.6,
      pi * 1.2,
      false,
      stroke,
    );

    // Star in center
    canvas.drawCircle(center, 4.0, Paint()..color = primaryColor..style = PaintingStyle.fill);
  }

  /// 🎭 Role-Play Dialogues: Two interlinked conversational speech balloons
  void _drawRolePlayArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left bubble
    final bubbleLeft = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 14, center.dy - 6), width: 32, height: 22),
      const Radius.circular(8),
    );
    canvas.drawRRect(bubbleLeft, Paint()..color = primaryColor.withAlpha(25));
    canvas.drawRRect(bubbleLeft, stroke);

    // Right bubble
    final bubbleRight = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 14, center.dy + 8), width: 34, height: 22),
      const Radius.circular(8),
    );
    canvas.drawRRect(bubbleRight, Paint()..color = primaryColor.withAlpha(40));
    canvas.drawRRect(bubbleRight, stroke);

    // Sound lines
    canvas.drawLine(Offset(center.dx - 22, center.dy - 6), Offset(center.dx - 6, center.dy - 6), stroke);
    canvas.drawLine(Offset(center.dx + 4, center.dy + 8), Offset(center.dx + 24, center.dy + 8), stroke);
  }

  /// 🌲 Story Branch: Branching narrative decision tree
  void _drawStoryBranchArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Root node
    canvas.drawCircle(Offset(center.dx, center.dy - 16), 5, stroke);
    canvas.drawCircle(Offset(center.dx, center.dy - 16), 3, Paint()..color = primaryColor);

    // Branch lines
    canvas.drawLine(Offset(center.dx, center.dy - 11), Offset(center.dx - 18, center.dy + 6), stroke);
    canvas.drawLine(Offset(center.dx, center.dy - 11), Offset(center.dx + 18, center.dy + 6), stroke);

    // Left & Right choice nodes
    canvas.drawCircle(Offset(center.dx - 18, center.dy + 10), 4.5, stroke);
    canvas.drawCircle(Offset(center.dx + 18, center.dy + 10), 4.5, stroke);

    // Sub branch
    canvas.drawLine(Offset(center.dx + 18, center.dy + 14), Offset(center.dx + 28, center.dy + 22), stroke);
    canvas.drawCircle(Offset(center.dx + 28, center.dy + 24), 3, Paint()..color = primaryColor);
  }

  /// 🏰 Phrasal Verb Dungeon: Dungeon portcullis & magical keys
  void _drawPhrasalDungeonArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Portcullis arch
    final arch = Path()
      ..moveTo(center.dx - 20, center.dy + 20)
      ..lineTo(center.dx - 20, center.dy - 6)
      ..arcToPoint(Offset(center.dx + 20, center.dy - 6), radius: const Radius.circular(20))
      ..lineTo(center.dx + 20, center.dy + 20);
    canvas.drawPath(arch, stroke);

    // Vertical bars
    canvas.drawLine(Offset(center.dx - 10, center.dy - 3), Offset(center.dx - 10, center.dy + 20), stroke);
    canvas.drawLine(Offset(center.dx, center.dy - 6), Offset(center.dx, center.dy + 20), stroke);
    canvas.drawLine(Offset(center.dx + 10, center.dy - 3), Offset(center.dx + 10, center.dy + 20), stroke);

    // Horizontal crossbar
    canvas.drawLine(Offset(center.dx - 20, center.dy + 8), Offset(center.dx + 20, center.dy + 8), stroke);
  }

  /// 🗝️ Idiom Escape Room: Etymological key and locked vault portal
  void _drawIdiomEscapeArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Vault circle
    canvas.drawCircle(Offset(center.dx - 8, center.dy), 16, stroke);
    canvas.drawCircle(Offset(center.dx - 8, center.dy), 10, Paint()..color = primaryColor.withAlpha(30));

    // Dial marks
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final p1 = Offset(center.dx - 8 + cos(angle) * 12, center.dy + sin(angle) * 12);
      final p2 = Offset(center.dx - 8 + cos(angle) * 16, center.dy + sin(angle) * 16);
      canvas.drawLine(p1, p2, stroke);
    }

    // Key on the right
    final keyHead = Offset(center.dx + 18, center.dy - 8);
    canvas.drawCircle(keyHead, 4, stroke);
    canvas.drawLine(Offset(center.dx + 18, center.dy - 4), Offset(center.dx + 18, center.dy + 14), stroke);
    canvas.drawLine(Offset(center.dx + 18, center.dy + 6), Offset(center.dx + 22, center.dy + 6), stroke);
    canvas.drawLine(Offset(center.dx + 18, center.dy + 12), Offset(center.dx + 23, center.dy + 12), stroke);
  }

  /// ✉️ Mini Email Boss: Diplomatic wax seal & envelope
  void _drawEmailBossArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Envelope body
    final env = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 44, height: 30),
      const Radius.circular(6),
    );
    canvas.drawRRect(env, Paint()..color = primaryColor.withAlpha(25));
    canvas.drawRRect(env, stroke);

    // Flap
    final flap = Path()
      ..moveTo(center.dx - 22, center.dy - 15)
      ..lineTo(center.dx, center.dy + 2)
      ..lineTo(center.dx + 22, center.dy - 15);
    canvas.drawPath(flap, stroke);

    // Wax seal
    canvas.drawCircle(Offset(center.dx, center.dy + 2), 6, Paint()..color = primaryColor);
    canvas.drawCircle(Offset(center.dx, center.dy + 2), 6, stroke);
  }

  /// 🃏 Custom Decks: Staggered flashcard stack with plus sign
  void _drawCustomDecksArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Back card
    final backCard = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 4, center.dy - 4), width: 34, height: 44),
      const Radius.circular(6),
    );
    canvas.drawRRect(backCard, Paint()..color = primaryColor.withAlpha(20));
    canvas.drawRRect(backCard, stroke);

    // Front card
    final frontCard = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 4, center.dy + 4), width: 34, height: 44),
      const Radius.circular(6),
    );
    canvas.drawRRect(frontCard, Paint()..color = const Color(0xFF161B26));
    canvas.drawRRect(frontCard, stroke);

    // Card lines & badge
    canvas.drawLine(Offset(center.dx - 14, center.dy - 4), Offset(center.dx + 6, center.dy - 4), stroke);
    canvas.drawLine(Offset(center.dx - 14, center.dy + 2), Offset(center.dx + 2, center.dy + 2), stroke);
    canvas.drawCircle(Offset(center.dx - 2, center.dy + 14), 4, Paint()..color = primaryColor);
  }

  /// ⚖️ Nuance Duel: Precise balance beam weighing two lexical tokens
  void _drawNuanceDuelArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Fulcrum
    final fulcrum = Path()
      ..moveTo(center.dx, center.dy - 2)
      ..lineTo(center.dx - 7, center.dy + 16)
      ..lineTo(center.dx + 7, center.dy + 16)
      ..close();
    canvas.drawPath(fulcrum, Paint()..color = primaryColor.withAlpha(40));
    canvas.drawPath(fulcrum, stroke);

    // Beam (slight angle for dynamic tension)
    canvas.drawLine(Offset(center.dx - 22, center.dy - 7), Offset(center.dx + 22, center.dy + 3), stroke);

    // Left pan
    canvas.drawLine(Offset(center.dx - 22, center.dy - 7), Offset(center.dx - 22, center.dy + 3), stroke);
    canvas.drawArc(Rect.fromCenter(center: Offset(center.dx - 22, center.dy + 6), width: 14, height: 8), 0, pi, false, stroke);

    // Right pan
    canvas.drawLine(Offset(center.dx + 22, center.dy + 3), Offset(center.dx + 22, center.dy + 13), stroke);
    canvas.drawArc(Rect.fromCenter(center: Offset(center.dx + 22, center.dy + 16), width: 14, height: 8), 0, pi, false, stroke);
  }

  /// 🔀 Register Shifter: Slider knob morphing from casual curve to formal classical pillar
  void _drawRegisterShifterArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Track
    canvas.drawLine(Offset(center.dx - 24, center.dy), Offset(center.dx + 24, center.dy), stroke);

    // Left side: informal speech ripple
    final ripple = Path()
      ..moveTo(center.dx - 24, center.dy - 10)
      ..quadraticBezierTo(center.dx - 20, center.dy - 16, center.dx - 16, center.dy - 10);
    canvas.drawPath(ripple, stroke);

    // Center toggle knob
    canvas.drawCircle(Offset(center.dx + 4, center.dy), 7, Paint()..color = primaryColor);
    canvas.drawCircle(Offset(center.dx + 4, center.dy), 7, stroke);

    // Right side: formal column icon
    canvas.drawLine(Offset(center.dx + 18, center.dy - 12), Offset(center.dx + 26, center.dy - 12), stroke);
    canvas.drawLine(Offset(center.dx + 20, center.dy - 12), Offset(center.dx + 20, center.dy - 2), stroke);
    canvas.drawLine(Offset(center.dx + 24, center.dy - 12), Offset(center.dx + 24, center.dy - 2), stroke);
  }

  /// ⚡ Paraphrase Blitz: Three orbiting arrows reorganizing core concept
  void _drawParaphraseBlitzArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Core idea circle
    canvas.drawCircle(center, 5, Paint()..color = primaryColor);

    // 3 orbital arcs
    canvas.drawArc(Rect.fromCircle(center: center, radius: 16), 0.2, 1.6, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: center, radius: 16), 2.3, 1.6, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: center, radius: 16), 4.4, 1.6, false, stroke);

    // Flash/lightning accent
    final bolt = Path()
      ..moveTo(center.dx + 18, center.dy - 12)
      ..lineTo(center.dx + 14, center.dy - 4)
      ..lineTo(center.dx + 19, center.dy - 4)
      ..lineTo(center.dx + 13, center.dy + 8);
    canvas.drawPath(bolt, stroke);
  }

  /// 🔨 Collocation Forge: Blacksmith anvil and forged interlocking link
  void _drawCollocationForgeArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Anvil base
    final anvil = Path()
      ..moveTo(center.dx - 16, center.dy + 14)
      ..lineTo(center.dx + 16, center.dy + 14)
      ..lineTo(center.dx + 12, center.dy + 6)
      ..lineTo(center.dx + 18, center.dy + 6)
      ..lineTo(center.dx + 14, center.dy - 2)
      ..lineTo(center.dx - 18, center.dy - 2)
      ..lineTo(center.dx - 12, center.dy + 6)
      ..lineTo(center.dx - 16, center.dy + 14);
    canvas.drawPath(anvil, Paint()..color = primaryColor.withAlpha(30));
    canvas.drawPath(anvil, stroke);

    // Hammer striking down
    final hammerHead = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 2, center.dy - 14), width: 14, height: 8),
      const Radius.circular(2),
    );
    canvas.drawRRect(hammerHead, stroke);
    canvas.drawLine(Offset(center.dx + 2, center.dy - 18), Offset(center.dx + 14, center.dy - 24), stroke);

    // Spark dots
    canvas.drawCircle(Offset(center.dx - 8, center.dy - 6), 1.5, Paint()..color = primaryColor);
    canvas.drawCircle(Offset(center.dx + 10, center.dy - 8), 1.5, Paint()..color = primaryColor);
  }

  /// 🎙️ Lecture Notes: Academic podium, acoustic waves and notepad
  void _drawLectureNotesArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Notepad on left
    final pad = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 10, center.dy), width: 22, height: 30),
      const Radius.circular(4),
    );
    canvas.drawRRect(pad, Paint()..color = primaryColor.withAlpha(25));
    canvas.drawRRect(pad, stroke);

    // Lines on pad
    canvas.drawLine(Offset(center.dx - 17, center.dy - 7), Offset(center.dx - 3, center.dy - 7), stroke);
    canvas.drawLine(Offset(center.dx - 17, center.dy), Offset(center.dx - 3, center.dy), stroke);
    canvas.drawLine(Offset(center.dx - 17, center.dy + 7), Offset(center.dx - 8, center.dy + 7), stroke);

    // Sound wave arcs on right
    canvas.drawArc(Rect.fromCircle(center: Offset(center.dx + 10, center.dy), radius: 8), -pi * 0.4, pi * 0.8, false, stroke);
    canvas.drawArc(Rect.fromCircle(center: Offset(center.dx + 10, center.dy), radius: 15), -pi * 0.4, pi * 0.8, false, stroke);
  }

  /// 🏛️ Debate Mode: Gavel striking plinth with two competing viewpoints
  void _drawDebateModeArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Sound block / plinth
    final block = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 12), width: 34, height: 8),
      const Radius.circular(3),
    );
    canvas.drawRRect(block, Paint()..color = primaryColor.withAlpha(35));
    canvas.drawRRect(block, stroke);

    // Gavel head
    final gavel = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 4, center.dy - 2), width: 18, height: 10),
      const Radius.circular(3),
    );
    canvas.drawRRect(gavel, stroke);

    // Gavel handle
    canvas.drawLine(Offset(center.dx - 4, center.dy - 7), Offset(center.dx + 16, center.dy - 18), stroke);

    // Impact burst lines
    canvas.drawLine(Offset(center.dx - 10, center.dy + 6), Offset(center.dx - 14, center.dy + 2), stroke);
    canvas.drawLine(Offset(center.dx + 2, center.dy + 6), Offset(center.dx + 6, center.dy + 2), stroke);
  }

  /// 🔗 Cohesion Fixer: Chain link interlocking disjointed text blocks
  void _drawCohesionFixerArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left chain ring
    final leftRing = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 10, center.dy), width: 22, height: 14),
      const Radius.circular(7),
    );
    canvas.drawRRect(leftRing, stroke);

    // Right chain ring
    final rightRing = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 10, center.dy), width: 22, height: 14),
      const Radius.circular(7),
    );
    canvas.drawRRect(rightRing, stroke);

    // Central interlocking tie dot
    canvas.drawCircle(center, 3, Paint()..color = primaryColor);
  }

  /// 🌿 Real English Log: Field notebook with magnifying lens on wild leaf
  void _drawRealEnglishLogArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Field book
    final book = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 6, center.dy), width: 28, height: 34),
      const Radius.circular(4),
    );
    canvas.drawRRect(book, Paint()..color = primaryColor.withAlpha(20));
    canvas.drawRRect(book, stroke);

    // Spine
    canvas.drawLine(Offset(center.dx - 14, center.dy - 17), Offset(center.dx - 14, center.dy + 17), stroke);

    // Magnifying lens on bottom right
    canvas.drawCircle(Offset(center.dx + 12, center.dy + 4), 9, stroke);
    canvas.drawLine(Offset(center.dx + 18, center.dy + 11), Offset(center.dx + 24, center.dy + 18), stroke);
  }

  /// ✒️ Style & Rhetoric Analyzer: Quill pen with ink droplet & classic parchment
  void _drawStyleAnalyzerArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Classic scroll
    final scrollPath = Path()
      ..moveTo(center.dx - 22, center.dy - 16)
      ..cubicTo(center.dx - 12, center.dy - 20, center.dx + 10, center.dy - 12, center.dx + 20, center.dy - 16)
      ..lineTo(center.dx + 20, center.dy + 16)
      ..cubicTo(center.dx + 10, center.dy + 12, center.dx - 12, center.dy + 20, center.dx - 22, center.dy + 16)
      ..close();
    canvas.drawPath(scrollPath, Paint()..color = primaryColor.withValues(alpha: 0.15));
    canvas.drawPath(scrollPath, stroke);

    // Quill pen angled across
    final quillPath = Path()
      ..moveTo(center.dx + 16, center.dy - 22)
      ..quadraticBezierTo(center.dx + 2, center.dy - 8, center.dx - 10, center.dy + 8)
      ..lineTo(center.dx - 12, center.dy + 12)
      ..lineTo(center.dx - 8, center.dy + 10)
      ..quadraticBezierTo(center.dx + 6, center.dy - 2, center.dx + 22, center.dy - 16)
      ..close();
    canvas.drawPath(quillPath, Paint()..color = const Color(0xFFF59E0B).withValues(alpha: 0.3));
    canvas.drawPath(quillPath, Paint()..color = const Color(0xFFF59E0B)..style = PaintingStyle.stroke..strokeWidth = 1.8);

    // Ink droplet
    canvas.drawCircle(Offset(center.dx - 14, center.dy + 15), 2.5, Paint()..color = const Color(0xFFF59E0B));
  }

  /// 📖 Great Works & Essays (C2): Open antique leatherbound codex with golden bookmark
  void _drawC2LongReaderArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Open book pages left & right
    final leftPage = Path()
      ..moveTo(center.dx, center.dy + 14)
      ..quadraticBezierTo(center.dx - 14, center.dy + 10, center.dx - 26, center.dy + 14)
      ..lineTo(center.dx - 26, center.dy - 14)
      ..quadraticBezierTo(center.dx - 14, center.dy - 18, center.dx, center.dy - 14)
      ..close();

    final rightPage = Path()
      ..moveTo(center.dx, center.dy + 14)
      ..quadraticBezierTo(center.dx + 14, center.dy + 10, center.dx + 26, center.dy + 14)
      ..lineTo(center.dx + 26, center.dy - 14)
      ..quadraticBezierTo(center.dx + 14, center.dy - 18, center.dx, center.dy - 14)
      ..close();

    canvas.drawPath(leftPage, Paint()..color = primaryColor.withValues(alpha: 0.2));
    canvas.drawPath(leftPage, stroke);
    canvas.drawPath(rightPage, Paint()..color = primaryColor.withValues(alpha: 0.2));
    canvas.drawPath(rightPage, stroke);

    // Golden bookmark ribbon dangling
    final ribbon = Path()
      ..moveTo(center.dx - 2, center.dy - 14)
      ..lineTo(center.dx - 2, center.dy + 20)
      ..lineTo(center.dx + 1, center.dy + 17)
      ..lineTo(center.dx + 4, center.dy + 20)
      ..lineTo(center.dx + 4, center.dy - 14)
      ..close();
    canvas.drawPath(ribbon, Paint()..color = const Color(0xFFF59E0B));
  }

  /// 📊 Linguistic Evaluator: Spectrum equalizer bars & diamond precision reticle
  void _drawLinguisticEvaluatorArt(Canvas canvas, Size size, Offset center) {
    final paint = Paint()..color = primaryColor;
    final heights = [12.0, 22.0, 32.0, 26.0, 18.0, 28.0];
    final startX = center.dx - 25;

    for (int i = 0; i < heights.length; i++) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + i * 9, center.dy + 14 - heights[i], 6, heights[i]),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, paint..color = (i % 2 == 0 ? primaryColor : const Color(0xFF10B981)));
    }

    // Diagnostic diamond reticle
    final diamond = Path()
      ..moveTo(center.dx + 18, center.dy - 14)
      ..lineTo(center.dx + 24, center.dy - 8)
      ..lineTo(center.dx + 18, center.dy - 2)
      ..lineTo(center.dx + 12, center.dy - 8)
      ..close();
    canvas.drawPath(diamond, Paint()..color = const Color(0xFF38BDF8)..style = PaintingStyle.stroke..strokeWidth = 1.8);
  }

  /// 🎯 Lexical Gap Finder: Radar sweep circle with isolated missing puzzle fragment
  void _drawGapFinderArt(Canvas canvas, Size size, Offset center) {
    final stroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer radar ring
    canvas.drawCircle(center, 22, stroke);
    canvas.drawCircle(center, 12, Paint()..color = primaryColor.withValues(alpha: 0.15));

    // Radar crosshairs
    canvas.drawLine(Offset(center.dx - 22, center.dy), Offset(center.dx + 22, center.dy), Paint()..color = primaryColor.withValues(alpha: 0.4));
    canvas.drawLine(Offset(center.dx, center.dy - 22), Offset(center.dx, center.dy + 22), Paint()..color = primaryColor.withValues(alpha: 0.4));

    // Blip pulse target
    canvas.drawCircle(Offset(center.dx + 8, center.dy - 8), 4, Paint()..color = const Color(0xFFEF4444));
    canvas.drawCircle(Offset(center.dx + 8, center.dy - 8), 7, Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.3));
  }

  @override
  bool shouldRepaint(covariant _GameArtPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.isDark != isDark;
}
