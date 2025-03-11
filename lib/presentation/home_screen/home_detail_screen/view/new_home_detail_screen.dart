import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/presentation/home_screen/home_screen/model/event_model.dart';

class NewHomeDetailScreen extends StatelessWidget {
  final EventModel events;
  const NewHomeDetailScreen({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  events.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: size.height * 1 / 3,
                ),
                Positioned(
                  top: padding * 4,
                  left: padding * 2,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: fontSize * 1.1,
                        ),
                      ),
                      SizedBox(width: padding),
                      Text(
                        'Event Details',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize * 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              events.title,
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              events.price ?? "Not Available",
              style: GoogleFonts.urbanist(
                color: Color(0xff3579DD),
                fontSize: fontSize * 0.9,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "About this Event",
              style: GoogleFonts.urbanist(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              events.description ?? "Not Available",
              style: GoogleFonts.urbanist(
                color: Colors.white70,
                fontSize: fontSize * 0.8,
              ),
            ),
            Text(
              events.date,
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
            Text(
              events.location,
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
