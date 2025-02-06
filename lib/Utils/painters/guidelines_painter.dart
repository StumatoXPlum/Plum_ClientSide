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
        Offset(10, y),
        Offset(10, y + dashWidth),
        paint,
      );

      canvas.drawLine(
        Offset(size.width - 10, y),
        Offset(size.width - 10, y + dashWidth),
        paint,
      );
      y += dashWidth + dashSpace;
    }


    final horizontalLinePositions = [
      size.height * 0.15,
      size.height * 0.58,
      size.height * 1,
    ];

    final horizontalLineLength = 25.0;

    for (final position in horizontalLinePositions) {

      double x = 10 -
          horizontalLineLength;
      while (x < 10) {

        canvas.drawLine(
          Offset(x, position),
          Offset(x + dashWidth, position),
          paint,
        );
        x += dashWidth + dashSpace;
      }


      x = size.width - 10;
      while (x < size.width - 10 + horizontalLineLength) {

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
