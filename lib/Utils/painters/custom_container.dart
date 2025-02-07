import 'package:flutter/material.dart';

class CustomContainer extends CustomPainter {
  final double containerWidth;
  final double containerHeight;

  CustomContainer(this.containerWidth, this.containerHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(30, 0)
      ..lineTo(containerWidth - 30, 0)
      ..lineTo(containerWidth - 30, 10)
      ..lineTo(containerWidth - 10, 10)
      ..lineTo(containerWidth - 10, containerHeight)
      ..lineTo(10, containerHeight)
      ..lineTo(10, 10)
      ..lineTo(30, 10)
      ..close();

    canvas.drawLine(
      Offset(30, 10),
      Offset(containerWidth - 30, 10),
      paint,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}