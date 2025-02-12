import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:task1/Streaks/View%20Modal/streaks_vm.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              // Left content column
              Positioned(
                bottom: 65,
                child: LeftColumn(
                  data: streakDummyData,
                ),
              ),
              // Right side: custom painted card
              Positioned(
                right: 1,
                bottom: 70,
                child: CustomPaint(
                  painter: GuidelinesPainter(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: 100,
                    child: Swiper(
                      scrollDirection: Axis.vertical,
                      layout: SwiperLayout.STACK,
                      itemCount: streakDummyData.length,
                      loop: true,
                      autoplay: true,
                      duration: 1000,
                      itemWidth: MediaQuery.of(context).size.width * 0.50,
                      itemHeight: 80,
                      itemBuilder: (context, index) {
                        return CustomCard(
                          streakData: streakDummyData[index],
                        );
                      },
                    ),
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
  final StreaksVm streakData;
  const CustomCard({super.key, required this.streakData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.1;
    final circleSize = containerHeight * 0.45;
    final horizontalPadding = size.width * 0.04;
    final verticalPadding = containerHeight * 0.15;
    final titleSize = size.width * 0.04;
    final amountSize = size.width * 0.035;
    final streakSize = size.width * 0.025;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 1),
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: horizontalPadding * 0.75),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        streakData.type,
                        style: AppTextStyles.gilroyBold.copyWith(
                          color: Colors.white,
                          fontSize: titleSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.25,
                        minWidth: size.width * 0.15,
                      ),
                      child: Text(
                        streakData.amount,
                        style: AppTextStyles.gilroyRegular.copyWith(
                          color: Colors.white,
                          fontSize: amountSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.green,
                      size: streakSize,
                    ),
                    Flexible(
                      child: Text(
                        '${streakData.streakCount}X STREAK',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: streakSize,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeftColumn extends StatelessWidget {
  final List<StreaksVm> data;
  const LeftColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      children: [
        Text(
          "${data[0].investmentCount} investments have\nan ${data[0].monthCount} month streak",
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
