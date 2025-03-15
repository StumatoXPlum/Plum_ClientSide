import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/ticket_cubit.dart';
import '../painter/ticket_painter.dart';

class TicketView extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final String ticketType;
  final String sideText;

  const TicketView({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.ticketType,
    required this.sideText,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.04;
    double ticketHeight = size.height * 0.20;

    return SizedBox(
      width: double.infinity,
      height: ticketHeight,
      child: CustomPaint(
        painter: TicketPainter(color: const Color(0xFF3679DC)),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.15,
              child: RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      sideText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize * 0.8,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padding * 3.5,
                  padding * 1.2,
                  padding * 1.5,
                  padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize * 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Expanded(
                      child: Text(
                        date,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: fontSize * 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        time,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: fontSize * 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Expanded(
                      flex: 2,
                      child: Text(
                        location,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontSize * 0.9,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    const Divider(color: Colors.white70, thickness: 0.5),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            ticketType,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize * 1,
                            ),
                          ),
                        ),
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
  }
}

class TicketWidget extends StatelessWidget {
  const TicketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        if (state is TicketLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                child: TicketView(
                  title: state.ticket.id,
                  date: state.ticket.date,
                  time: state.ticket.time,
                  location: state.ticket.location,
                  ticketType: "${state.ticket.quantity} Tickets",
                  sideText: state.ticket.id,
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeCap: StrokeCap.round,
            ),
          );
        }
      },
    );
  }
}
