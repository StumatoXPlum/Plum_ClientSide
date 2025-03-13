import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_detail_screen/view/new_home_detail_screen.dart';
import '../model/event_model.dart';

class EventListScreen extends StatelessWidget {
  final List<EventModel> events;
  final String title;

  const EventListScreen({super.key, required this.events, required this.title});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: const Color(0xff090D14),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewHomeDetailScreen(event: event),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 0.6,
                  vertical: padding * 0.6,
                ),
                margin: EdgeInsets.symmetric(vertical: padding * 0.6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        event.imageUrl,
                        width: size.width * 0.2,
                        height: size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: padding,
                          horizontal: padding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              '${event.location} - ${event.date}',
                              style: GoogleFonts.urbanist(
                                color: Colors.white70,
                                fontSize: fontSize * 0.7,
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
          },
        ),
      ),
    );
  }
}
