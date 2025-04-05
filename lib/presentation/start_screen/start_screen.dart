import '../../user_onboarding/sign_up_screen/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;

    return Scaffold(
      backgroundColor: const Color(0xff1F265E),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/start_screen_assets/start.svg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: size.height * 0.2,
              child: Text(
                "Welcome to Aloha Funds",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: fontSize * 1.5,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.27,
              child: Text(
                "Aloha Funds – Your Daily Market Compass: \nNavigate financial tides with clarity, \nconfidence, and smart strategies.",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: fontSize * 0.9,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: size.height * 0.06,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: padding,
                      horizontal: padding * 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff8E97FD),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: Text(
                      "GET STARTED",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
