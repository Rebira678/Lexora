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
  gradedReader,
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
      case GameArtType.gradedReader:
        _drawGradedReaderArt(canvas, size, center);
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

  @override
  bool shouldRepaint(covariant _GameArtPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.isDark != isDark;
}
