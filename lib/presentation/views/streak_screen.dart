import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/painters/custom_container.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({
    super.key,
    required this.name,
    required this.amount,
    required this.streakCount,
    this.onCheckNowPressed,
  });

  final String name;
  final String amount;
  final String streakCount;
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 25,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              CustomPaint(
                painter: GuidelinesPainter(),
                child: CustomCard(),
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
    return CustomPaint(
      painter: CustomContainer(),
      child: Container(
        width: 200,
        height: 65,
        padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cook',
                  style: AppTextStyles.gilroyBold.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.green, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '3X STREAK',
                      style: AppTextStyles.gilroyRegular.copyWith(
                        color: Colors.green,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              '₹6,700',
              style: AppTextStyles.gilroyRegular.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
