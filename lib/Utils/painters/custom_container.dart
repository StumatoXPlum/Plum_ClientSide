import 'package:flutter/material.dart';

class CustomContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Calculate relative dimensions
    final width = size.width;
    final height = size.height;
    final indent = width * 0.05;
    final topHeight = height * 0.1;
    final rightIndent = width * 0.95;

    final path = Path()
      ..moveTo(indent * 3, 0)
      ..lineTo(rightIndent - indent * 2, 0)
      ..lineTo(rightIndent - indent * 2, topHeight)
      ..lineTo(rightIndent, topHeight)
      ..lineTo(rightIndent, height)
      ..lineTo(indent, height)
      ..lineTo(indent, topHeight)
      ..lineTo(indent * 3, topHeight)
      ..close();

    canvas.drawLine(
      Offset(indent * 3, topHeight),
      Offset(rightIndent - indent * 2, topHeight),
      paint,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
