import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: padding),
        decoration: BoxDecoration(
          color: const Color(0xFF3579DD),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: size.width * 0.1,
                  height: size.height * 0.03,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
                : Text(
                  buttonText,
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
      ),
    );
  }
}
