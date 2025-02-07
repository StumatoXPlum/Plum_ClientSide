import 'package:flutter/material.dart';
import 'package:task1/Streaks/View%20Modal/streaks_vm.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';
import 'package:task1/Utils/painters/custom_container.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';

class StreakScreen extends StatelessWidget {
  StreakScreen({
    super.key,
    this.name,
    this.amount,
    this.streakCount,
    this.onCheckNowPressed,
  });

  final String? name;
  final String? amount;
  final String? streakCount;
  final VoidCallback? onCheckNowPressed;
  final streakDummyData = DummyStreaksData.getDummyStreaksData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Stack(
            children: [
              // Left content column
              Positioned(
                  bottom: 65,
                  child: LeftColumn(
                    data: streakDummyData,
                  )),
              // Right side: custom painted card
              Positioned(
                right: 1,
                bottom: 70,
                child: CustomPaint(
                  painter: GuidelinesPainter(),
                  child: CustomCard(
                    width: MediaQuery.of(context).size.width * 0.5,
                    streakData: streakDummyData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final double width;
  final StreaksVm streakData;
  const CustomCard({super.key, required this.width, required this.streakData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.10;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: CustomContainer(width, containerHeight),
        child: Container(
          width: width,
          height: containerHeight,
          padding: const EdgeInsets.fromLTRB(16, 20, 10, 12),
          child: Row(
            children: [
              Container(
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            streakData.type,
                            style: AppTextStyles.gilroyBold.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                            textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.08),
                        Flexible(
                          child: Text(
                            streakData.amount,
                            style: AppTextStyles.gilroyRegular.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                            textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.002),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.green,
                          size: screenWidth * 0.020,
                        ),
                        SizedBox(width: screenWidth * 0.005),
                        Text(
                          '${streakData.streakCount}X STREAK',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: screenWidth * 0.020,
                            letterSpacing: 1,
                          ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),
                      ],
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

class LeftColumn extends StatelessWidget {
  final StreaksVm data;
  const LeftColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      children: [
        Text(
          "${data.investmentCount} investments have\nan ${data.monthCount} month streak",
          style: AppTextStyles.dentonBold.copyWith(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
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
              right: Radius.circular(MediaQuery.of(context).size.width * 0.05),
              left: Radius.circular(MediaQuery.of(context).size.width * 0.05),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CHECK NOW",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
                textScaler:
                    TextScaler.linear(ScaleSize.textScaleFactor(context)),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: MediaQuery.of(context).size.width * 0.045,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
