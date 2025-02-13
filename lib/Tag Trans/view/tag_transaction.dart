import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task1/Tag%20Trans/View%20Model/tag_vm.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';

class TagTransaction extends StatelessWidget {
  const TagTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final tagData = TagVm.dummyData;
    final size = MediaQuery.of(context).size;
    final textScale = ScaleSize.textScaleFactor(context);

    return Scaffold(
      body: Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tagData.title,
                    style: AppTextStyles.dentonBold.copyWith(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    tagData.subtitle,
                    style: AppTextStyles.dentonBold.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    textScaler: TextScaler.linear(textScale),
                  ),
                  SizedBox(height: size.height * 0.020),
                  GestureDetector(
                    onTap: () {
                      print(tagData.ctaAction);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.015,
                        vertical: MediaQuery.of(context).size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tagData.ctaText,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.018,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
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
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SvgPicture.network(
                      tagData.assetUrl,
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
