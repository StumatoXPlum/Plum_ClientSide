import 'package:flutter/material.dart';
import 'package:task1/Recurring/Model/recurring_model.dart';
import 'package:task1/Recurring/View%20Model/recurring_vm.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';
import 'package:task1/Utils/painters/custom_container.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';

class RecurringPaymentScreen extends StatelessWidget {
  RecurringPaymentScreen({
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
  final recurringData = DummyRecurringData.getMockRecurringData();

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
                  bottom: 55,
                  child: LeftColumn(
                    data: recurringData,
                  )),
              // Right side: custom painted container
              Positioned(
                right: 1,
                bottom: 70,
                child: CustomPaint(
                  painter: GuidelinesPainter(),
                  child: ContainerData(
                    width: MediaQuery.of(context).size.width * 0.5,
                    data: recurringData,
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

class ContainerData extends StatelessWidget {
  final double width;
  const ContainerData({super.key, required this.width, required this.data});

  final RecurringVm data;
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
                            data.type,
                            style: AppTextStyles.gilroyBold.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth * 0.035,
                            ),
                            textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.08),
                        Flexible(
                          child: Text(
                            data.amount,
                            style: AppTextStyles.gilroyRegular.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.002),
                    Text(
                      'PAID ${data.date}',
                      style: AppTextStyles.gilroyRegular.copyWith(
                        color: Colors.white60,
                        fontSize: 8,
                        letterSpacing: 1,
                      ),
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      overflow: TextOverflow.ellipsis,
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
  final RecurringVm data;
  const LeftColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      children: [
        Text(
          "${data.count}  recurring\npayments detected",
          style: AppTextStyles.dentonBold.copyWith(
            fontSize: 14,
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
                "ADD NOW",
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
