import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Widget? child;
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    double fontSize = size.width * 0.05;
    return SizedBox(
      height: size.height * 0.08,
      width: double.infinity,
      child: NeoPopTiltedButton(
        isFloating: true,
        onTapUp: onTap,
        decoration: NeoPopTiltedButtonDecoration(
          showShimmer: true,
          shimmerColor: Colors.white60,
          color: Color(0xFF0D0D0D),
          plunkColor: Color(0xFF3579DD),
          shadowColor: Colors.white10,
          border: Border.fromBorderSide(
            BorderSide(color: Color(0xFF3579DD), width: 1),
          ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
