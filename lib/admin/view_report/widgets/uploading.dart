import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class UploadingDialogContent extends StatelessWidget {
  const UploadingDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.04;
    double fontSize = size.width * 0.045;
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.5,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xff1F265E),
        border: Border.all(color: Color(0xff8E97FD)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/report_assets/upload.json',
            height: size.height * 0.3,
            width: double.infinity,
            repeat: true,
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            "Your report is being uploaded.\nPlease don't close the app.",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
