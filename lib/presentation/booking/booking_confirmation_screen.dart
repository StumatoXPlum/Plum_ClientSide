import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen/home_screen/model/event_model.dart';
import '../ticket/cubit/ticket_cubit.dart';
import '../ticket/model/ticket_model.dart';
import '../payment/view/payment_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final EventModel event;
  const BookingConfirmationScreen({super.key, required this.event});

  @override
  BookingConfirmationScreenState createState() =>
      BookingConfirmationScreenState();
}

class BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int ticketCount = 1;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    double pricePerTicket =
        double.tryParse(
          widget.event.price
                  ?.split('-')
                  .first
                  .replaceAll(RegExp(r'[^0-9]'), '') ??
              '0',
        ) ??
        0;
    double totalPrice = ticketCount * pricePerTicket;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Book Tickets",
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                        vertical: padding * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff191A24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.event.imageUrl,
                              width: size.width * 0.2,
                              height: size.width * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
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
                                    fontSize: fontSize * 0.8,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/home_assets/calendar.svg',
                                      width: size.width * 0.02,
                                      height: size.height * 0.02,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xff3579DD),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      _formatDateTime(
                                        widget.event.date,
                                        widget.event.time,
                                      ),
                                      style: GoogleFonts.urbanist(
                                        color: Colors.white70,
                                        fontSize: fontSize * 0.7,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/home_assets/pin1.svg',
                                      width: size.width * 0.02,
                                      height: size.height * 0.02,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xff3579DD),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.event.location,
                                            style: GoogleFonts.urbanist(
                                              color: Colors.white70,
                                              fontSize: fontSize * 0.7,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            widget.event.address ??
                                                "Not Available",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.white70,
                                              fontSize: fontSize * 0.7,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      child: Divider(color: Colors.white54, thickness: 0.5),
                    ),
                    Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: const Color(0xff191A24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Tickets",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${widget.event.price} / per person",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white70,
                                    fontSize: fontSize * 0.8,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap:
                                    ticketCount > 1
                                        ? () => setState(() => ticketCount--)
                                        : null,
                                child: Container(
                                  width: size.width * 0.07,
                                  height: size.height * 0.07,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff262730),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: fontSize * 0.8,
                                  ),
                                ),
                              ),
                              SizedBox(width: padding),
                              Text(
                                "$ticketCount",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: padding),
                              InkWell(
                                onTap: () => setState(() => ticketCount++),
                                child: Container(
                                  width: size.width * 0.07,
                                  height: size.height * 0.07,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff262730),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: fontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: const Color(0xff191A24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Total Price",
                            style: GoogleFonts.urbanist(
                              color: Colors.white70,
                              fontSize: fontSize * 0.9,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "AED $totalPrice",
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: SizedBox(
              width: double.infinity,
              height: size.height * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3579DD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final ticket = TicketModel(
                    title: widget.event.title,
                    date: widget.event.date,
                    time: widget.event.time ?? "TBA",
                    location: widget.event.location,
                    quantity: ticketCount,
                    id: widget.event.title,
                  );
                  context.read<TicketCubit>().setTicket(ticket);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(ticket: ticket),
                    ),
                  );
                },
                child: Text(
                  "Proceed to Payment",
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? date, String? time) {
    if (date == null) return "TBA";

    final dateComponents = date.split(' ');
    if (dateComponents.length >= 2) {
      final month = dateComponents[0];
      final day = dateComponents[1].replaceAll(',', '');

      String timeStr = "";
      if (time != null && time.isNotEmpty && time != "Not Available") {
        timeStr = ", $time";
      }

      return "$month $day$timeStr";
    }
    return date;
  }
}
