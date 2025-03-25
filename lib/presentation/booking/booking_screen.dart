import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../ticket/cubit/ticket_cubit.dart';
import '../ticket/view/ticket_widget.dart';

class BookingScreen extends StatefulWidget {
  final bool fromSubmitButton;
  const BookingScreen({super.key, this.fromSubmitButton = false});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.fromSubmitButton ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              Container(
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  color: const Color(0xff090D14),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(32),
                    right: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: ToggleSwitch(
                    minWidth: double.infinity,
                    activeBgColors: const [
                      [Color(0xff3579DD)],
                      [Color(0xff3579DD)],
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: const Color(0xffF6F5F9),
                    inactiveFgColor: Colors.black,
                    initialLabelIndex: _selectedIndex,
                    totalSwitches: 2,
                    labels: const ['Your Bookings', 'Group Bookings'],
                    customTextStyles: [
                      GoogleFonts.urbanist(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                    radiusStyle: true,
                    onToggle: (index) {
                      if (index != null) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child:
                    _selectedIndex == 0
                        ? _yourBookingsList()
                        : _groupBookingsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _yourBookingsList() {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        if (state is TicketLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TicketLoaded) {
          if (state.tickets.isEmpty) {
            return Center(
              child: Text(
                "No tickets booked yet",
                style: GoogleFonts.urbanist(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.tickets.length,
            itemBuilder: (context, index) {
              final reversedIndex = state.tickets.length - 1 - index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TicketWidget(ticket: state.tickets[reversedIndex]),
              );
            },
          );
        } else if (state is TicketError) {
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.urbanist(color: Colors.white),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _groupBookingsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchGroupBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error fetching group bookings",
              style: GoogleFonts.urbanist(color: Colors.white),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No group bookings yet",
              style: GoogleFonts.urbanist(color: Colors.white),
            ),
          );
        }
        final groupBookings = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: groupBookings.length,
          itemBuilder: (context, index) {
            final booking = groupBookings[index];
            return _buildBookingCard(booking);
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchGroupBookings() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('responses').select();
    return response;
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1E1E2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bookingDetail("Name", booking['full_name'] ?? "N/A"),
          _bookingDetail("Contact", booking['contact_number'] ?? "N/A"),
          _bookingDetail("Email", booking['email'] ?? "N/A"),
          _bookingDetail("Occasion", booking['occasion'] ?? "N/A"),
          _bookingDetail(
            "Number of Guests",
            booking['number_of_guests']?.toString() ?? "N/A",
          ),
          _bookingDetail("Preferred Date", booking['preferred_date'] ?? "N/A"),
          _bookingDetail("Alternate Date", booking['alternate_date'] ?? "N/A"),
          _bookingDetail(
            "Time",
            "${booking['start_time'] ?? 'N/A'} - ${booking['end_time'] ?? 'N/A'}",
          ),
          _bookingDetail(
            "Exclusive Venue",
            (booking['exclusive_venue'] is bool)
                ? (booking['exclusive_venue'] ? "Yes" : "No")
                : (booking['exclusive_venue'] ?? "Not specified"),
          ),
          _bookingDetail(
            "Preferred Venue",
            booking['preferred_venue_type'] ?? "Not specified",
          ),
          _bookingDetail(
            "Desired location or area",
            booking['desired_location_or_area'] ?? "No additional info",
          ),
          _bookingDetail(
            "Vibe of Event",
            booking['vibe_of_event'] ?? "No additional info",
          ),
          _bookingDetail(
            "Event Description",
            booking['event_description'] ?? "No additional info",
          ),
          _bookingDetail(
            "Budget",
            booking['budget_amount']?.toString() ?? "No additional info",
          ),
          _bookingDetail(
            "Additional Requirements",
            booking['additional_requirements'] ?? "No additional info",
          ),
        ],
      ),
    );
  }

  Widget _bookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: value,
              style: GoogleFonts.urbanist(
                color: Colors.white70,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
