import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task2/presentation/ticket/model/ticket_model.dart';
import '../payment/view/payment_screen.dart';
import '../points_screen/view/points_screen.dart';

class ApplePayScreen extends StatefulWidget {
  final TicketModel ticket;
  const ApplePayScreen({super.key,required this.ticket});

  @override
  ApplePayScreenState createState() => ApplePayScreenState();
}

class ApplePayScreenState extends State<ApplePayScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PaymentSuccessDialog(),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PointsScreen(ticket: widget.ticket,)),
        );
      });
    });
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
