import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/core/custom_widgets/bottom_navigation_bar.dart';

class OnSubmitScreen extends StatefulWidget {
  const OnSubmitScreen({super.key});

  @override
  State<OnSubmitScreen> createState() => _OnSubmitScreenState();
}

class _OnSubmitScreenState extends State<OnSubmitScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavScreen(initialIndex: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/home_assets/layer.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: size.height * 0.16,
            child: Image.asset(
              'assets/home_assets/merged.png',
              fit: BoxFit.cover,
              height: size.height * 0.5,
              width: size.width * 0.7,
            ),
          ),
          Positioned(
            top: size.height * 0.6,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
              child: Text(
                "Sit back and relax we're getting everything ready for you!",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize * 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
