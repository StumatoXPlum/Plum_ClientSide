import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ticket/cubit/ticket_cubit.dart';
import '../ticket/view/ticket_widget.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        title: Text(
          "Your Bookings",
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TicketLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TicketWidget(),
            );
          } else if (state is TicketError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.urbanist(color: Colors.white),
              ),
            );
          }
          return Center(
            child: Text(
              "No bookings found",
              style: GoogleFonts.urbanist(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
