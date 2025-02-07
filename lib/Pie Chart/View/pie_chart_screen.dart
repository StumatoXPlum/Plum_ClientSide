import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rive/rive.dart';
import 'package:task1/Utils/fonts/text_scaling.dart';

class MoneyInAndOutConstants {
  static const int maxPieSplit = 6;
}

class Assets {
  static const String riveMoneyInAndOutPie =
      'assets/rive/money_in_and_out_pie.riv';
}

class HomeVisualSectionItemVm {
  final double percentage;
  HomeVisualSectionItemVm({required this.percentage});
}

class InAndOutPieGraph extends StatefulWidget {
  final bool isLoading;
  final int colorNumber;
  final List<HomeVisualSectionItemVm> items;
  final void Function(int)? onPieSectionTap;

  const InAndOutPieGraph({
    Key? key,
    this.isLoading = false,
    required this.items,
    required this.colorNumber,
    this.onPieSectionTap,
  }) : super(key: key);

  @override
  _InAndOutPieGraphState createState() => _InAndOutPieGraphState();
}

class _InAndOutPieGraphState extends State<InAndOutPieGraph>
    with TickerProviderStateMixin {
  final int delayBetweenPieSplitAnimations = 200; // in milliseconds
  final double dummyPieStartDegreeOffset = 270.0;
  final Duration updatePieSplitsDelay = Duration(milliseconds: 200);

  final List<SMINumber?> valueInputs = [];
  final List<AnimationController> animationControllers = [];
  final List<Timer> pieAnimDelayTimers = [];

  SMITrigger? loadingTrigger;
  SMITrigger? successTrigger;
  SMINumber? colorValueInput;
  Timer? updatePieSplitsTimer;
  StateMachineController? stateMachineController;

  @override
  void didUpdateWidget(covariant InAndOutPieGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      updatePieGraph();
    }
    if (oldWidget.colorNumber != widget.colorNumber) {
      colorValueInput?.value = widget.colorNumber.toDouble();
    }
  }

  @override
  void dispose() {
    for (final controller in animationControllers) {
      controller.dispose();
    }
    for (final timer in pieAnimDelayTimers) {
      timer.cancel();
    }
    updatePieSplitsTimer?.cancel();
    super.dispose();
  }

  void updatePieGraph() {
    if (widget.isLoading) {
      loadingTrigger?.fire();
      resetPieSplits();
    } else {
      successTrigger?.fire();
      updatePieSplitsTimer?.cancel();
      updatePieSplitsTimer = Timer(updatePieSplitsDelay, () {
        updatePieSplits(widget.items);
      });
    }
  }

  void updatePieSplits(List<HomeVisualSectionItemVm> items) {
    double currPercent = 100.0;
    int riveValueIndex = 0;

    for (final controller in animationControllers) {
      controller.dispose();
    }
    for (final timer in pieAnimDelayTimers) {
      timer.cancel();
    }
    animationControllers.clear();
    pieAnimDelayTimers.clear();

    for (int index = 0; index < items.length; index++) {
      final item = items[index];
      if (index > 0) {
        SMINumber? input;
        if (riveValueIndex < valueInputs.length) {
          input = valueInputs[riveValueIndex];
        }
        final pieValue = currPercent;
        final animController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        );
        animationControllers.add(animController);

        animController.addListener(() {
          final value =
              pieValue * Curves.easeInOut.transform(animController.value);
          if (input != null) {
            input.value = value;
          }
        });

        pieAnimDelayTimers.add(
          Timer(
              Duration(
                  milliseconds:
                      riveValueIndex * delayBetweenPieSplitAnimations), () {
            if (mounted) {
              animController.reset();
              animController.forward();
            }
          }),
        );
        riveValueIndex++;
      }
      currPercent -= item.percentage;
    }

    for (int index = riveValueIndex;
        index < MoneyInAndOutConstants.maxPieSplit - 1;
        index++) {
      if (index < valueInputs.length) {
        valueInputs[index]?.value = 0.0;
      }
    }

    if (animationControllers.isNotEmpty) {
      animationControllers.last.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          stateMachineController?.isActive = false;
        }
      });
    }
  }

  void resetPieSplits() {
    for (final e in valueInputs) {
      if (e != null) {
        e.value = 0;
      }
    }
  }

  void onRiveInit(Artboard artboard) {
    final stateController =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (stateController != null) {
      stateMachineController = stateController;
      artboard.addController(stateController);

      loadingTrigger = stateController.findInput<bool>("Loader") as SMITrigger?;
      successTrigger =
          stateController.findInput<bool>("Success") as SMITrigger?;
      colorValueInput =
          stateController.findInput<double>("Color") as SMINumber?;

      valueInputs.clear();

      for (int valueNumber = 2;
          valueNumber <= MoneyInAndOutConstants.maxPieSplit;
          valueNumber++) {
        final input = stateController.findInput<double>("Value0$valueNumber")
            as SMINumber?;
        valueInputs.add(input);
      }

      colorValueInput?.value = widget.colorNumber.toDouble();

      updatePieGraph();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pieSize = screenWidth * 0.5;
    final dummyPieSectionRadius = pieSize * 0.24;
    final items = widget.items;

    return SizedBox(
      height: pieSize,
      width: pieSize,
      child: Stack(
        children: [
          RepaintBoundary(
            child: RiveAnimation.asset(
              Assets.riveMoneyInAndOutPie,
              fit: BoxFit.contain,
              onInit: onRiveInit,
            ),
          ),
          Positioned.fill(
            child: items.isNotEmpty
                ? PieChart(
                    PieChartData(
                      sections: items.reversed.map((item) {
                        return PieChartSectionData(
                          value: item.percentage,
                          showTitle: false,
                          radius: dummyPieSectionRadius,
                          color: Colors.transparent,
                        );
                      }).toList(),
                      startDegreeOffset: dummyPieStartDegreeOffset,
                      sectionsSpace: 0,
                      pieTouchData: PieTouchData(
                        touchCallback: (touchEvent, pieTouchResponse) {
                          if (touchEvent is FlTapUpEvent) {
                            final index = pieTouchResponse
                                ?.touchedSection?.touchedSectionIndex;
                            if (index != null && index >= 0) {
                              // Reverse the index so that it matches the order of your [items] list.
                              final reversedIndex = items.length - 1 - index;
                              if (reversedIndex >= 0) {
                                widget.onPieSectionTap?.call(reversedIndex);
                              }
                            }
                          }
                        },
                      ),
                    ),
                    swapAnimationDuration: Duration(milliseconds: 0),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class PieChartScreen extends StatelessWidget {
  const PieChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<HomeVisualSectionItemVm> pieChartData = [
      HomeVisualSectionItemVm(percentage: 50.0),
      HomeVisualSectionItemVm(percentage: 30.0),
      HomeVisualSectionItemVm(percentage: 20.0),
      HomeVisualSectionItemVm(percentage: 70.0),
    ];

    return Scaffold(
      body: Container(
        height: 270,
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    height: 29,
                    child: Text(
                      "AMOUNT SPENT ON TRANSPORTATION",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        height: 1.51,
                        letterSpacing: 1.61,
                        color: Color(0xB3FFFFFF),
                      ),
                      textAlign: TextAlign.start,
                      textScaler:
                          TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '₹11,250',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Denton',
                            fontWeight: FontWeight.w700,
                            height: 1.71,
                            letterSpacing: 0.12,
                          ),
                        ),
                        const TextSpan(
                          text: '.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Denton',
                            fontWeight: FontWeight.w300,
                            height: 1.71,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                    textScaler:
                        TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                  const SizedBox(height: 10),
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
                          "VIEW CASH FLOW",
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
            ),
            Expanded(
              child: Center(
                child: InAndOutPieGraph(
                  items: pieChartData,
                  colorNumber: 2,
                  onPieSectionTap: (index) {
                    debugPrint("Tapped pie section: $index");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
