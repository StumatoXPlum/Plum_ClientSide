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

    // Vertical dotted lines (left and right)
    double y = -50;
    while (y < size.height + 50) {
      // Left vertical dotted line
      canvas.drawLine(
        Offset(10, y),
        Offset(10, y + dashWidth),
        paint,
      );
      // Right vertical dotted line
      canvas.drawLine(
        Offset(size.width - 10, y),
        Offset(size.width - 10, y + dashWidth),
        paint,
      );
      y += dashWidth + dashSpace;
    }

    // Horizontal position
    final horizontalLinePositions = [
      size.height * 0.15,
      size.height * 0.58,
      size.height * 1,
    ];

    final horizontalLineLength = 25.0;

    for (final position in horizontalLinePositions) {
      // Left horizontal dotted line (extending to the left)
      double x = 10 -
          horizontalLineLength; // Start from the left edge and extend outward
      while (x < 10) {
        // Draw until the left edge of the container
        canvas.drawLine(
          Offset(x, position),
          Offset(x + dashWidth, position),
          paint,
        );
        x += dashWidth + dashSpace;
      }

      // Right horizontal dotted line (extending to the right)
      x = size.width - 10; // Start from the right edge of the container
      while (x < size.width - 10 + horizontalLineLength) {
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
