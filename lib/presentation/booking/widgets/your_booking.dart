import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ticket/cubit/ticket_cubit.dart';
import '../../ticket/view/ticket_widget.dart';

class YourBookingsList extends StatelessWidget {
  const YourBookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        if (state is TicketLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is TicketLoaded) {
          if (state.tickets.isEmpty) {
            return _emptyMessage("No tickets booked yet");
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
          return _emptyMessage(state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _emptyMessage(String message) {
    return Center(
      child: Text(message, style: GoogleFonts.urbanist(color: Colors.white)),
    );
  }
}
