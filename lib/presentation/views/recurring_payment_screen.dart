import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/painters/custom_container.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';

class RecurringPaymentScreen extends StatelessWidget {
  const RecurringPaymentScreen({
    super.key,
    this.type,
    this.amount,
    this.date,
    this.onCheckNowPressed,
  });

  final String? type;
  final String? amount;
  final String? date;
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
              // Left content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  children: [
                    Text(
                      "2 recurring\npayments detected",
                      style: AppTextStyles.dentonBold.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                            "ADD NOW",
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF000000),
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right side: custom painted container
              CustomPaint(
                painter: GuidelinesPainter(),
                child: const ContainerData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerData extends StatelessWidget {
  const ContainerData({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomContainer(),
      child: Container(
        width: 200,
        height: 80, // Increased height to prevent overflow
        padding: const EdgeInsets.fromLTRB(16, 24, 24, 14),
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Cook',
                        style: AppTextStyles.gilroyBold.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
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
                  const SizedBox(height: 2),
                  Text(
                    'PAID ON 02 AUG',
                    style: AppTextStyles.gilroyRegular.copyWith(
                      color: Colors.white60,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
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
