import 'package:flutter/material.dart';

class CustomContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(30, 0)
      ..lineTo(170, 0)
      ..lineTo(170, 10)
      ..lineTo(190, 10)
      ..lineTo(190, size.height)
      ..lineTo(10, size.height)
      ..lineTo(10, 10)
      ..lineTo(30, 10)
      ..close();

    canvas.drawLine(
      Offset(30, 10),
      Offset(170, 10),
      paint,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
