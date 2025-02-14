import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:task1/streaks_info/model/streaks_model.dart';
import 'package:task1/streaks_info/view_model/streaks_vm.dart';
import 'package:task1/utils/fonts/fonts.dart';
import 'package:task1/utils/fonts/text_scaling.dart';
import 'package:task1/utils/painters/guidelines_painter.dart';

class StreakScreen extends StatelessWidget {
  StreakScreen({
    super.key,
    required DummyStreaksData streaksVM,
  });

  final DummyStreaksData streaksVM = DummyStreaksData();

  @override
  Widget build(BuildContext context) {
    StreaksModel streakData = streaksVM.getStreaksData();
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
                  data: streakData,
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
                          axisDirection: AxisDirection.up,
                          layout: SwiperLayout.STACK,
                          itemCount: streakData.cardData.length,
                          loop: true,
                          autoplay: true,
                          duration: 1000,
                          itemWidth: MediaQuery.of(context).size.width * 0.50,
                          itemHeight: 60,
                          itemBuilder: (context, index) {
                            return CustomCard(
                              streaksCard: streakData.cardData[index],
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

class CustomCard extends StatelessWidget {
  final StreaksCard streaksCard;
  const CustomCard({super.key, required this.streaksCard});

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
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
            ),
            child: Text(streaksCard.logo),
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
                        streaksCard.title,
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
                        maxWidth: size.width * 0.2,
                        minWidth: size.width * 0.12,
                      ),
                      child: Text(
                        '₹${streaksCard.amount}',
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
                Flexible(
                  child: Text(
                    streaksCard.subtitle,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: streakSize,
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
  final StreaksModel data;
  const LeftColumn({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacing = size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          data.title,
          style: AppTextStyles.dentonBold.copyWith(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
          textScaler: TextScaler.linear(
            ScaleSize.textScaleFactor(context),
          ),
        ),
        SizedBox(height: spacing * 0.035),
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
                data.ctaText,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.018,
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
