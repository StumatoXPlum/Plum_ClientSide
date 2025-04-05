import 'package:aloha_funds/core/bottom_navigation_bar.dart';
import 'package:aloha_funds/core/custom_widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessDialogContent extends StatelessWidget {
  const SuccessDialogContent({super.key});

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
          SvgPicture.asset(
            'assets/report_assets/done.svg',
            height: size.height * 0.3,
            width: double.infinity,
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            "Your report has been submitted successfully!",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.03),
          ButtonWidget(
            buttonText: "Close",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BottomNavScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
