import 'package:dotted_line/dotted_line.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../questions_screens/view/personal_info/cubit/personal_info_cubit.dart';

class GroupBookingsList extends StatelessWidget {
  final PersonalInfoState personalInfoState;
  GroupBookingsList({super.key, required this.personalInfoState});

  final List<String> _bookingImages = [
    "assets/bookings/booking1.svg",
    "assets/bookings/booking2.svg",
    "assets/bookings/booking3.svg",
    "assets/bookings/booking4.svg",
    "assets/bookings/booking5.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchGroupBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snapshot.hasError) {
          return _errorMessage("Error fetching group bookings");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _errorMessage("No group bookings yet");
        }
        final groupBookings = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: groupBookings.length,
          itemBuilder: (context, index) {
            final reversed = groupBookings.length - 1 - index;
            final booking = groupBookings[reversed];
            final int imageIndex =
                booking['id'].hashCode.abs() % _bookingImages.length;
            final String imagePath = _bookingImages[imageIndex];
            return _buildBookingCard(booking, imagePath, context);
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchGroupBookings() async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('responses')
        .select('*, users(name, phonenumber, email)')
        .eq('users.email', supabase.auth.currentUser?.email as Object);

    return data;
  }

  Widget _errorMessage(String message) {
    return Center(
      child: Text(message, style: GoogleFonts.urbanist(color: Colors.white)),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "N/A";
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat("MMM d, yyyy").format(parsedDate);
    } catch (e) {
      return "Invalid date";
    }
  }

  String _formatTime(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return "N/A";
    try {
      DateTime parsedStartTime = DateFormat("HH:mm").parse(startTime);
      DateTime parsedEndTime = DateFormat("HH:mm").parse(endTime);
      return "${DateFormat.jm().format(parsedStartTime)} - ${DateFormat.jm().format(parsedEndTime)}";
    } catch (e) {
      return "Invalid time";
    }
  }

  Widget _buildBookingCard(
    Map<String, dynamic> booking,
    String imagePath,
    BuildContext context,
  ) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: _buildFrontSide(booking, imagePath, context),
      back: _buildBackSide(booking, context, size, padding, fontSize),
    );
  }

  Widget _buildFrontSide(
    Map<String, dynamic> booking,
    String imagePath,
    BuildContext context,
  ) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    final personalInfoState = context.watch<PersonalInfoCubit>().state;
    String hostName =
        personalInfoState.fullName.isNotEmpty
            ? personalInfoState.fullName
            : booking['users']['name'] ?? "N/A";
    return Container(
      margin: EdgeInsets.only(bottom: padding),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              child: SvgPicture.asset(
                imagePath,
                height: size.height * 0.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.025),
          DottedLine(dashColor: Colors.white70),
          SizedBox(height: size.height * 0.02),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: padding),
            decoration: BoxDecoration(
              color: const Color(0xff1E1E2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    booking['occasion'] ?? "N/A",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Hosted by: $hostName",
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: size.height * 0.02,
                        children: [
                          _detailText(
                            "Date",
                            _formatDate(booking['preferred_date']),
                            Icons.calendar_month_outlined,
                            context,
                          ),

                          _detailText(
                            "Guests",
                            booking['number_of_guests']?.toString(),
                            Icons.people_outline,
                            context,
                          ),
                          _detailText(
                            "Vibe of Event",
                            booking['vibe_of_event'],
                            Icons.emoji_emotions_outlined,
                            context,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: size.height * 0.02,
                        children: [
                          _detailText(
                            "Time",
                            _formatTime(
                              booking['start_time'],
                              booking['end_time'],
                            ),
                            Icons.timer_outlined,
                            context,
                          ),
                          _detailText(
                            "Venue",
                            booking['preferred_venue_type'],
                            Icons.home_outlined,
                            context,
                          ),
                          _detailText(
                            "City",
                            booking['desired_location_or_area'],
                            Icons.location_city_outlined,
                            context,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            "Tap to view details",
            style: GoogleFonts.urbanist(
              color: Colors.white70,
              fontSize: fontSize * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBackSide(
  Map<String, dynamic> booking,
  BuildContext context,
  Size size,
  double padding,
  double fontSize,
) {
  final personalInfoState = context.watch<PersonalInfoCubit>().state;
  return Container(
    margin: EdgeInsets.only(bottom: padding),
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: const Color(0xff252836),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Additional Details",
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        DottedLine(dashColor: Colors.white30),
        SizedBox(height: size.height * 0.02),
        _detailText(
          "Event Details",
          booking['event_description'],
          Icons.description_outlined,
          context,
        ),
        SizedBox(height: size.height * 0.02),
        _detailText(
          "Additional Requirements",
          booking['additional_requirements'],
          Icons.dashboard_customize_outlined,
          context,
        ),
        SizedBox(height: size.height * 0.02),
        _detailText(
          "Event Budget",
          "${booking['budget_amount']?.toString()} AED",
          Icons.attach_money,
          context,
        ),
        SizedBox(height: size.height * 0.02),
        Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white30, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                "Host Details",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              DottedLine(dashColor: Colors.white30),
              SizedBox(height: size.height * 0.02),

              _detailText(
                "Full Name",
                personalInfoState.fullName.isNotEmpty
                    ? personalInfoState.fullName
                    : booking['users']['name'],
                Icons.person,
                context,
              ),
              _detailText(
                "Contact",
                personalInfoState.contactNumber.isNotEmpty
                    ? personalInfoState.contactNumber
                    : booking['users']['phonenumber'],
                Icons.phone_android_sharp,
                context,
              ),
              _detailText(
                "Email",
                personalInfoState.email.isNotEmpty
                    ? personalInfoState.email
                    : booking['users']['email'],
                Icons.mail_outline,
                context,
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Align(
          alignment: Alignment.center,
          child: Text(
            "Tap to flip back",
            style: GoogleFonts.urbanist(
              color: Colors.white70,
              fontSize: fontSize * 0.8,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _detailText(String title, String? value, IconData icon, context) {
  final Size size = MediaQuery.of(context).size;
  double padding = size.width * 0.04;
  double fontSize = size.width * 0.045;
  return Padding(
    padding: EdgeInsets.only(bottom: padding * 0.3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: fontSize * 1.2, color: Colors.white70),
        SizedBox(width: padding * 0.5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize * 0.9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value ?? 'N/A',
                style: GoogleFonts.urbanist(
                  color: Colors.white70,
                  fontSize: fontSize * 0.9,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
