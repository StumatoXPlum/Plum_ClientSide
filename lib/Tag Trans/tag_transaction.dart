import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';

class TagTransaction extends StatelessWidget {
  const TagTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "tag transactions\nfor better insights",
                    style: AppTextStyles.dentonBold.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.015,
                      vertical: MediaQuery.of(context).size.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            MediaQuery.of(context).size.width * 0.05),
                        left: Radius.circular(
                            MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "TAG TRANSACTIONS",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/tag_design.svg',
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withAlpha(255),
                              Colors.black.withAlpha(100),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 1.0],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
