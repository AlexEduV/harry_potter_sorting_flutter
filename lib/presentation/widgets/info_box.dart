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
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: CustomPaint(
              painter: _GlassPainter(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
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
      colors: const [
        Color(0xFF4A90D9), // blue
        Color(0x884A90D9), // blue semi-transparent
        Color(0x004A90D9), // transparent (blue hue, avoids grey corridor)
        Color(0x00795548), // transparent (brown hue)
        Color(0xFF795548), // brown – bottom-left
        Color(0x00795548), // transparent (brown hue)
        Color(0x004A90D9), // transparent (blue hue)
        Color(0x884A90D9), // blue semi-transparent
        Color(0xFF4A90D9), // blue – back to top-right
      ],
      stops: [0.0, 0.1, 0.25, 0.38, 0.5, 0.62, 0.75, 0.9, 1.0],
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

// Semi-transparent glass base + pencil-stroke texture.
class _GlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.white.withOpacity(0.18),
    );

    final random = Random(42);
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.6;

    for (int i = 0; i < 220; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final length = random.nextDouble() * 5.0 + 1.5;
      final angle = random.nextDouble() * pi; // pencil strokes are directional, not radial
      final opacity = random.nextDouble() * 0.1 + 0.03;

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + cos(angle) * length, y + sin(angle) * length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GlassPainter old) => false;
}
