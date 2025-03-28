import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:task2/presentation/ticket/model/ticket_model.dart';
import '../points_screen/view/points_screen.dart';

class ApplePayScreen extends StatefulWidget {
  final TicketModel ticket;
  const ApplePayScreen({super.key, required this.ticket});

  @override
  ApplePayScreenState createState() => ApplePayScreenState();
}

class ApplePayScreenState extends State<ApplePayScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      _showPaymentSuccessDialog();
    });
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PaymentSuccessDialog(),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context, true);
        _navigateToPointsScreen();
      }
    });
  }

  void _navigateToPointsScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => PointsScreen(ticket: widget.ticket),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: SafeArea(
        child: Center(
          child: Lottie.asset("assets/animations/2.json", repeat: false),
        ),
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Dialog(
      insetPadding: EdgeInsets.all(padding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(padding * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/receipt_assets/check.svg"),
            SizedBox(height: size.height * 0.02),
            Text(
              "Checkout Success!",
              style: GoogleFonts.urbanist(
                fontSize: fontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "Your booking is confirmed.",
              style: GoogleFonts.urbanist(
                fontSize: fontSize * 0.7,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            const CircularProgressIndicator(color: Color(0xff3579DD)),
          ],
        ),
      ),
    );
  }
}
