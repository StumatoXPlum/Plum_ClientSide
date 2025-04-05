import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool isLoading;
  const ButtonWidget({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double fontSize = size.width * 0.05;

    return SizedBox(
      height: size.height * 0.06,
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff8E97FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      buttonText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
