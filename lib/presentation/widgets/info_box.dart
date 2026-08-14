import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String value;
  final String description;

  const InfoBox({
    required this.value,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        foregroundPainter: _GradientBorderPainter(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CustomPaint(
            painter: _GlassPainter(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24.0,
                      color: Color(0xFF1A3A5C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF2C5282),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Sweeping gradient border: blue-dominated at top-right, brown-dominated at bottom-left.
class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const borderWidth = 3.5;
    const radius = 12.0;

    const gradient = SweepGradient(
      center: Alignment.center,
      startAngle: -pi / 4, // start at top-right corner
      endAngle: -pi / 4 + pi * 2,
      colors: [
        Color(0xFF4A90D9), // solid blue – top-right
        Color(0xF24A90D9), // gentle first step
        Color(0xCC4A90D9),
        Color(0x884A90D9),
        Color(0x444A90D9),
        Color(0x14607080), // faint neutral bridge – hue gap between blue and brown
        Color(0x44795548),
        Color(0x88795548),
        Color(0xCC795548),
        Color(0xFF795548), // solid brown – bottom-left
        Color(0xCC795548),
        Color(0x88795548),
        Color(0x44795548),
        Color(0x14607080), // faint neutral bridge – hue gap between brown and blue
        Color(0x444A90D9),
        Color(0x884A90D9),
        Color(0xCC4A90D9),
        Color(0xF24A90D9), // gentle last step
        Color(0xFF4A90D9), // solid blue – back to top-right
      ],
      stops: [
        0.0, 0.03, 0.0725, 0.145, 0.22,
        0.25,
        0.28, 0.355, 0.4275,
        0.5,
        0.5725, 0.645, 0.72,
        0.75,
        0.78, 0.855, 0.9275, 0.97,
        1.0,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          borderWidth / 2,
          borderWidth / 2,
          size.width - borderWidth,
          size.height - borderWidth,
        ),
        const Radius.circular(radius - borderWidth / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientBorderPainter old) => false;
}

// Aqua glass: blue gradient base + white gloss on top half + pencil texture.
class _GlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Blue gradient base
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD6EEF8), // ice blue
            Color(0xFFADD8EE), // aqua
            Color(0xFF8EC8E8), // deeper aqua
          ],
          stops: [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    // White gloss highlight on top ~42% — the defining Aqua element
    final glossRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.42);
    canvas.drawRect(
      glossRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.78),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(glossRect),
    );

    // Soft bottom reflection
    final reflectRect = Rect.fromLTWH(0, size.height * 0.72, size.width, size.height * 0.28);
    canvas.drawRect(
      reflectRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.22),
          ],
        ).createShader(reflectRect),
    );

    // Pencil texture — fixed seed so it never changes on rebuild
    final random = Random(42);
    final strokePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.6;

    for (int i = 0; i < 220; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final length = random.nextDouble() * 5.0 + 1.5;
      final angle = random.nextDouble() * pi;
      final opacity = random.nextDouble() * 0.1 + 0.03;

      strokePaint.color = Colors.white.withOpacity(opacity);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + cos(angle) * length, y + sin(angle) * length),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GlassPainter old) => false;
}
