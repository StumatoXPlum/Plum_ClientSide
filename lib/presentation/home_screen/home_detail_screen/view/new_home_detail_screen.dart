import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_button.dart';
import '../../../booking/booking_confirmation_screen.dart';
import '../widgets/details_container.dart';
import '../../home_screen/model/event_model.dart';

class NewHomeDetailScreen extends StatefulWidget {
  final EventModel event;
  const NewHomeDetailScreen({super.key, required this.event});

  @override
  State<NewHomeDetailScreen> createState() => _NewHomeDetailScreenState();
}

class _NewHomeDetailScreenState extends State<NewHomeDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    slideAnimation = Tween(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    controller.forward();
  }

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
                        widget.event.imageUrl,
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
                    child: SlideTransition(
                      position: slideAnimation,
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
                              widget.event.title,
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.event.artist,
                              style: GoogleFonts.urbanist(
                                color: Colors.white70,
                                fontSize: fontSize * 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: SlideTransition(
                      position: slideAnimation,
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
                                widget.event.description ?? "Not Available",
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
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: SlideTransition(
                      position: slideAnimation,
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
                              event: widget.event,
                              svgPath: 'assets/home_assets/booking.svg',
                              title: "Event Fee",
                              subtitle: '${widget.event.price} / per person',
                            ),
                            DetailsContainer(
                              event: widget.event,
                              svgPath: 'assets/home_assets/calendar.svg',
                              title: widget.event.date,
                              subtitle: widget.event.time ?? "Not Available",
                            ),
                            DetailsContainer(
                              event: widget.event,
                              svgPath: 'assets/home_assets/pin1.svg',
                              title: widget.event.location,
                              subtitle: widget.event.address ?? "Not Available",
                            ),
                            SizedBox(height: size.height * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: slideAnimation,
            child: Divider(color: Colors.white54, thickness: 0.5),
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: SlideTransition(
              position: slideAnimation,
              child: CustomButton(
                buttonText: "Book Event",
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:
                          (context) =>
                              BookingConfirmationScreen(event: widget.event),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }
}
