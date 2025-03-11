import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketView extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final String ticketType;
  final String sideText;

  const TicketView({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.ticketType,
    required this.sideText,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.04;
    double ticketHeight = size.height * 0.20;

    return SizedBox(
      width: double.infinity,
      height: ticketHeight,
      child: CustomPaint(
        painter: TicketPainter(color: const Color(0xFF3679DC)),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.15,
              child: RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      sideText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize * 0.8,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padding * 3.5,
                  padding * 1.2,
                  padding * 1.5,
                  padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize * 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Expanded(
                      child: Text(
                        "$date | $time",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: fontSize * 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Expanded(
                      flex: 2,
                      child: Text(
                        location,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 0.9,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    const Divider(color: Colors.white70, thickness: 0.5),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            ticketType,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding * 1.6,
            vertical: padding,
          ),
          child: Text(
            "Your tickets",
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: fontSize * 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: TicketView(
            title: "KV5 - YOGMUSIIC",
            date: "February 22, 2025",
            time: "07.00 PM",
            location: "Romeo Lane, Dubai",
            ticketType: "2 VIP Tickets",
            sideText: "SOUNDS by AKS",
          ),
        ),
      ],
    );
  }
}
