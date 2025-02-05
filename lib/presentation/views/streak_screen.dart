import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/painters/custom_container.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({
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
              Positioned(
                bottom: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "2 investments have\nan 8 month streak",
                      style: AppTextStyles.dentonBold.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(18),
                          left: Radius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "CHECK NOW",
                            style: AppTextStyles.gilroyBold.copyWith(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              height: 2,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 6,
                bottom: 70,
                child: CustomPaint(
                  painter: GuidelinesPainter(),
                  child: CustomCard(),
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
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return CustomPaint(
      painter: CustomContainer(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: screenWidth * 0.48,
        height: screenHeight * 0.086,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cook',
                        style: AppTextStyles.gilroyBold.copyWith(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹6,700',
                        style: AppTextStyles.gilroyRegular.copyWith(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.green,
                        size: 10,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '3X STREAK',
                        style: AppTextStyles.gilroyRegular.copyWith(
                          color: Colors.green,
                          fontSize: MediaQuery.of(context).size.width * 0.026,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
