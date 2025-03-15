import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../booking/booking_confirmation_screen.dart';
import '../widgets/details_container.dart';
import '../../home_screen/model/event_model.dart';

class NewHomeDetailScreen extends StatelessWidget {
  final EventModel event;
  const NewHomeDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        event.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: size.height * 1 / 3,
                      ),
                      Positioned(
                        top: padding * 5,
                        left: padding * 3,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
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
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff191A24),
                        borderRadius: BorderRadius.circular(10),
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
                          Text(
                            event.artist,
                            style: GoogleFonts.urbanist(
                              color: Colors.white70,
                              fontSize: fontSize * 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      decoration: BoxDecoration(
                        color: Color(0xff191A24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 1,
                            ),
                            child: Text(
                              "About this Event",
                              style: GoogleFonts.urbanist(
                                fontSize: fontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.003),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 1,
                            ),
                            child: Text(
                              event.description ?? "Not Available",
                              style: GoogleFonts.urbanist(
                                color: Colors.white70,
                                fontSize: fontSize * 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff191A24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: padding * 1,
                              top: padding,
                            ),
                            child: Text(
                              "Event Details",
                              style: GoogleFonts.urbanist(
                                fontSize: fontSize * 1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DetailsContainer(
                            event: event,
                            svgPath: 'assets/home_assets/booking.svg',
                            title: "Event Fee",
                            subtitle: '${event.price} / per person',
                          ),
                          DetailsContainer(
                            event: event,
                            svgPath: 'assets/home_assets/calendar.svg',
                            title: event.date,
                            subtitle: event.time ?? "Not Available",
                          ),
                          DetailsContainer(
                            event: event,
                            svgPath: 'assets/home_assets/pin1.svg',
                            title: event.location,
                            subtitle: event.address ?? "Not Available",
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.white54, thickness: 0.5),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding * 1.2,
            ),
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3579DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BookingConfirmationScreen(event: event),
                    ),
                  );
                },
                child: Text(
                  "Book Event",
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: fontSize * 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }
}
