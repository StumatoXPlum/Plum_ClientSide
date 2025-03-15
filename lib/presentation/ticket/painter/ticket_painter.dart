import 'package:flutter/material.dart';

class TicketPainter extends CustomPainter {
  final Color color;

  TicketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final double cornerRadius = size.height * 0.04;
    final double notchRadius = size.height * 0.05;
    final double leftSectionWidth = size.width * 0.20;
    final double dotLineX = leftSectionWidth;

    final Path path = Path();

    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);

    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(size.width, size.height - cornerRadius);

    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(cornerRadius, size.height);

    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.lineTo(0, cornerRadius);

    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    path.close();

    canvas.drawPath(path, paint);

    final Paint dottedLinePaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    const double dashHeight = 10;
    const double dashSpace = 4;
    double startY = notchRadius;

    while (startY < size.height - notchRadius) {
      canvas.drawLine(
        Offset(dotLineX, startY),
        Offset(dotLineX, startY + dashHeight),
        dottedLinePaint,
      );
      startY += dashHeight + dashSpace;
    }

    final Paint clearPaint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.clear;

    canvas.drawCircle(Offset(dotLineX, 0), notchRadius * 1.5, clearPaint);

    canvas.drawCircle(
      Offset(dotLineX, size.height),
      notchRadius * 1.5,
      clearPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
