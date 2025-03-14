import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home_screen/model/event_model.dart';

class DetailsContainer extends StatelessWidget {
  final EventModel event;
  final String svgPath;
  final String title;
  final String subtitle;
  const DetailsContainer({
    super.key,
    required this.event,
    required this.svgPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding * 1.6,
        vertical: padding * 0.6,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                svgPath,
                width: size.width * 0.04,
                height: size.height * 0.05,
                colorFilter: ColorFilter.mode(
                  Color(0xff3579DD),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize * 0.9,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.urbanist(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
