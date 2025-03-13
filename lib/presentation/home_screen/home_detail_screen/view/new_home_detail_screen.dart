import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../payment/view/payment_screen.dart';
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
                                size: fontSize * 1.2,
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
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                    child: Text(
                      '${event.title} with ${event.artist}',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontSize: fontSize * 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                    child: Text(
                      event.price ?? "Not Available",
                      style: GoogleFonts.urbanist(
                        color: Color(0xff3579DD),
                        fontSize: fontSize * 0.9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
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
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                    child: Text(
                      event.description ?? "Not Available",
                      style: GoogleFonts.urbanist(
                        color: Colors.white70,
                        fontSize: fontSize * 0.8,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                    child: Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/home_assets/calendar.svg",
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.date,
                                      style: GoogleFonts.urbanist(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize * 0.9,
                                      ),
                                    ),
                                    Text(
                                      event.time ?? "Not Available",
                                      style: GoogleFonts.urbanist(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: EdgeInsets.only(left: padding * 0.6),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/home_assets/pin1.svg"),
                                SizedBox(width: size.width * 0.05),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.location,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize * 0.9,
                                        ),
                                      ),
                                      Text(
                                        event.address ?? "Not Available",
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.white70, thickness: 1),
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
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
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
