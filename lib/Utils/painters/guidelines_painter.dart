import 'package:flutter/material.dart';

class GuidelinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final dashWidth = 3.0;
    final dashSpace = 2.0;

    double y = -50;
    while (y < size.height + 50) {
      canvas.drawLine(
        Offset(1, y),
        Offset(1, y + dashWidth),
        paint,
      );

      canvas.drawLine(
        Offset(size.width - 1, y),
        Offset(size.width - 1, y + dashWidth),
        paint,
      );
      y += dashWidth + dashSpace;
    }

    final horizontalLinePositions = [
      size.height * 0.11,
      size.height * 0.50,
      size.height * 0.89,
    ];

    final horizontalLineLength = 25.0;

    for (final position in horizontalLinePositions) {
      // Left horizontal dotted line (extending to the left)
      double x = 2 -
          horizontalLineLength; // Start from the left edge and extend outward
      while (x < 2) {
        // Draw until the left edge of the container
        canvas.drawLine(
          Offset(x, position),
          Offset(x + dashWidth, position),
          paint,
        );
        x += dashWidth + dashSpace;
      }

      // Right horizontal dotted line (extending to the right)
      x = size.width - 2; // Start from the right edge of the container
      while (x < size.width - 2 + horizontalLineLength) {
        // Draw until the end of the extended line
        canvas.drawLine(
          Offset(x, position),
          Offset(x + dashWidth, position),
          paint,
        );
        x += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
