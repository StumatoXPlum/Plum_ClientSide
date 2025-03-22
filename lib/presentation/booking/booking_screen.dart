import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../ticket/cubit/ticket_cubit.dart';
import '../ticket/view/ticket_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 0;

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
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TicketWidget(ticket: state.tickets[index]),
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
    return Center(
      child: Text(
        "No group bookings yet",
        style: GoogleFonts.urbanist(color: Colors.white),
      ),
    );
  }
}
