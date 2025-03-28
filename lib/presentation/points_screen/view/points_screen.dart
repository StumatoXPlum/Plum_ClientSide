import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:task2/core/custom_widgets/neopop_button.dart';
import '../../../core/custom_widgets/bottom_navigation_bar.dart';
import '../../ticket/model/ticket_model.dart';
import '../cubit/earned_points_cubit.dart';

class PointsScreen extends StatelessWidget {
  final TicketModel ticket;
  const PointsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: Column(
          children: [
            Lottie.asset("assets/animations/3.json"),
            Text(
              "You earned 20 points",
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "You can collect points and then use them to get discounts and exclusive offers",
              style: GoogleFonts.urbanist(
                color: Colors.white70,
                fontSize: fontSize * 0.7,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            NeopopButton(
              buttonText: "Back to Home",
              onTap: () {
                context.read<EarnedPointsCubit>().incrementPoints();
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => BottomNavScreen(initialIndex: 0),
                  ),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
