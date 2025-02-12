import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';
import 'package:task1/Utils/painters/guidelines_painter.dart';
import 'package:task1/bank_screen.dart/view%20modal/bank_vm.dart';

class BankScreen extends StatelessWidget {
  BankScreen({
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
  final interestDummyData = DummyinterestData.getDummyInterestData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Stack(
            children: [
              Positioned(
                bottom: 50,
                child: LeftColumn(
                  data: interestDummyData,
                ),
              ),
              Positioned(
                right: 1,
                bottom: 70,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      stops: [0.0, 0.6],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: GuidelinesPainter(),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 90,
                        ),
                      ),
                      Positioned.fill(
                        child: Swiper(
                          scrollDirection: Axis.vertical,
                          layout: SwiperLayout.STACK,
                          itemCount: interestDummyData.length,
                          loop: true,
                          autoplay: true,
                          duration: 1000,
                          itemWidth: MediaQuery.of(context).size.width * 0.50,
                          itemHeight: 60,
                          itemBuilder: (context, index) {
                            return InterestCard(
                              interestData: interestDummyData[index],
                            );
                          },
                        ),
                      ),
                    ],
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

class InterestCard extends StatelessWidget {
  final BankVm interestData;
  const InterestCard({super.key, required this.interestData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerHeight = size.height * 0.08;
    final circleSize = containerHeight * 0.4;
    final horizontalPadding = size.width * 0.03;
    final verticalPadding = containerHeight * 0.12;
    final titleSize = size.width * 0.035;
    final amountSize = size.width * 0.03;
    final streakSize = size.width * 0.02;

    return Container(
      width: size.width * 0.9,
      height: containerHeight,
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
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Icon(
                    Icons.percent,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: horizontalPadding * 0.6),
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
                        interestData.type,
                        style: AppTextStyles.gilroyBold.copyWith(
                          color: Color(0xB3FFFFFF),
                          fontSize: titleSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.2,
                        minWidth: size.width * 0.12,
                      ),
                      child: Text(
                        '+₹${interestData.interestAmount}',
                        style: AppTextStyles.gilroyRegular.copyWith(
                          color: Colors.white,
                          fontSize: amountSize,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.right,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    'INTEREST',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: streakSize,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
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
  final List<BankVm> data;
  const LeftColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = ScaleSize.textScaleFactor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          data[0].title,
          style: AppTextStyles.gilroyBold.copyWith(
            fontSize: size.width * 0.03,
            fontWeight: FontWeight.w700,
            height: 1.51,
            letterSpacing: size.width * 0.004,
            color: Color(0xB3FFFFFF),
          ),
          textAlign: TextAlign.start,
          textScaler: TextScaler.linear(textScale),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          '₹${data[0].amount}',
          style: AppTextStyles.dentonBold.copyWith(
            fontSize: size.width * 0.06,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
          textScaler: TextScaler.linear(textScale),
        ),
        SizedBox(height: size.height * 0.008),
        Row(
          children: [
            Container(
              height: size.width * 0.04,
              width: size.width * 0.04,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            SizedBox(width: size.width * 0.012),
            Text(
              data[0].bankName,
              style: AppTextStyles.gilroyBold.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.03,
                height: 1.51,
                letterSpacing: size.width * 0.004,
                color: Color(0xB3FFFFFF),
              ),
              textAlign: TextAlign.start,
              textScaler: TextScaler.linear(textScale),
            ),
            SizedBox(width: size.width * 0.012),
            Container(
              height: size.width * 0.015,
              width: size.width * 0.015,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: size.width * 0.012),
            Text(
              data[0].lastDigits,
              style: AppTextStyles.gilroyBold.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.03,
                height: 1.51,
                letterSpacing: size.width * 0.004,
                color: Color(0xB3FFFFFF),
              ),
              textAlign: TextAlign.start,
              textScaler: TextScaler.linear(textScale),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.02,
            vertical: size.height * 0.007,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(size.width * 0.05),
              left: Radius.circular(size.width * 0.05),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data[0].ctaText,
                style: TextStyle(
                  fontSize: size.width * 0.025,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  letterSpacing: size.width * 0.002,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(textScale),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: size.width * 0.045,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
