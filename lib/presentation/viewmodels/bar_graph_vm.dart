import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';

class MoneyBarGraph extends StatefulWidget {
  const MoneyBarGraph({
    super.key,
    required this.graphVm,
    required this.width,
    required this.height,
    this.onBarTap,
  });

  final MoneyBarGraphVm graphVm;
  final void Function(int, bool)? onBarTap;
  final double width;

  /// Height of the Bar Graph, Widget is not guaranteed to take this exact height due to
  /// some added decorations
  final double height;

  @override
  State<MoneyBarGraph> createState() => _MoneyBarGraphState();
}

class MoneyBarGraphVm {
  final List<MoneyBarGraphDataPointVm> dataPoints;
  final int selectedBarIndex;
  final double maxYAxisValue;
  final double? averageValue;
  final String? averageLabel;

  MoneyBarGraphVm({
    required this.dataPoints,
    required this.selectedBarIndex,
    required this.maxYAxisValue,
    this.averageValue,
    this.averageLabel,
  });

  int get numberOfBars => dataPoints.length;
}

class MoneyBarGraphDataPointVm {
  final String xLabel;
  final String? xSubLabel;
  final double yValue;
  final String? yLabel;

  MoneyBarGraphDataPointVm({
    required this.xLabel,
    this.xSubLabel,
    required this.yValue,
    this.yLabel,
  });
}

class _MoneyBarGraphState extends State<MoneyBarGraph> {
  final double _barWidth = 28;
  final double _barLabelHeight = 36;
  final double _averageLineHeight = 16;
  final double _barTooltipHeight = 22;
  final _visibilityDetectorKey = UniqueKey();

  late int _selectedIndex;
  bool _shouldAnimateFast = false;
  bool _shouldAnimate = true;
//  Timer? animationDelayTimer;
//  Timer? animationTimer;

  int delayDuration = 200, animationDuration = 500;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.graphVm.selectedBarIndex;
    widget.onBarTap?.call(_selectedIndex, false);
  }

//  void _alocateTimer() {
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      animationTimer = Timer(Duration(milliseconds: animationDuration), () {
//        setState(() {
//          _shouldAnimateFast = true;
//        });
//      });
//    });
//  }

//  @override
//  void dispose() {
//    animationDelayTimer?.cancel();
//    animationTimer?.cancel();
//    super.dispose();
//  }

  @override
  void didUpdateWidget(covariant MoneyBarGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.graphVm != oldWidget.graphVm) {
      _selectedIndex = widget.graphVm.selectedBarIndex;
      widget.onBarTap?.call(_selectedIndex, false);
    }
  }

  void _handleBarTap(int index) {
    final touchedIndexYValue = widget.graphVm.dataPoints[index].yValue;
    if (index != _selectedIndex && touchedIndexYValue > 0) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onBarTap?.call(index, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxYValue = widget.graphVm.maxYAxisValue;
    final averageValue = widget.graphVm.averageValue;
    final numberOfBars = widget.graphVm.numberOfBars;

    //  return VisibilityDetector(
    //    key: _visibilityDetectorKey,
    //    onVisibilityChanged: (!_shouldAnimate)
    //        ? null
    //        : (info) {
    //            if (info.visibleFraction > 0.75) {
    //              _alocateTimer();
    //              setState(() {
    //                _shouldAnimate = false;
    //              });
    //            }
    //          },
    return SizedBox(
      width: widget.width,
      height: widget.height + _barTooltipHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: _barTooltipHeight,
            bottom: 0,
            left: 0,
            right: 0,
            child: GraphGrid(numberOfBars, _barLabelHeight),
          ),
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: BarChart(
              swapAnimationCurve: Curves.easeInOutCubic,
              swapAnimationDuration: _shouldAnimateFast
                  ? const Duration(milliseconds: 150)
                  : Duration(milliseconds: animationDuration),
              BarChartData(
                //  barGroups: MoneyBarGraphUtils.getBarGroupData(
                //    dataPoints: widget.graphVm.dataPoints,
                //    barWidth: _barWidth,
                //    selectedIndex: _selectedIndex,
                //    zeroHeight: _shouldAnimate,
                //  ),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.spaceAround,
                gridData: const FlGridData(show: false),
                maxY: maxYValue,
                //  titlesData: MoneyBarGraphUtils.getTitlesData(
                //    titleWidgetGetter: (index) => DebounceGestureDetector(
                //      onTap: () => _handleBarTap(index),
                //      child: _BarLabel(
                //        label: widget.graphVm.dataPoints[index].xLabel,
                //        subLabel: widget.graphVm.dataPoints[index].xSubLabel,
                //      ),
                //    ),
                //    barLabelHeight: _barLabelHeight,
                //  ),
                barTouchData: BarTouchData(
                  handleBuiltInTouches: false,
                  touchCallback: (touchEvent, touchResponse) {
                    if (touchEvent is FlTapUpEvent) {
                      final touchedIndex =
                          touchResponse?.spot?.touchedBarGroupIndex;
                      if (touchedIndex == null) return;
                      _handleBarTap(touchedIndex);
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
                  ),
                ),
              ),
            ),
          ),
          if (averageValue != null) ...[
            Positioned(
              bottom: getAverageLinePosition(
                  maxYValue: maxYValue, averageValue: averageValue),
              left: 0,
              right: 0,
              height: _averageLineHeight,
              child: AverageLine(
                  averageLabel: widget.graphVm.averageLabel,
                  numberOfBars: numberOfBars),
            ),
          ],
          Positioned(
            bottom: _barLabelHeight,
            left: 0,
            right: 0,
            top: 0,
            child: _BarTooltips(
              numberOfBars: numberOfBars,
              dataPoints: widget.graphVm.dataPoints,
              barGraphHeight: widget.height,
              barLabelHeight: _barLabelHeight,
              maxYValue: maxYValue,
              selectedIndex: _selectedIndex,
              tooltipHeight: _barTooltipHeight,
            ),
          ),
        ],
      ),
    );
  }

  double getAverageLinePosition(
      {required double maxYValue, required double averageValue}) {
    final multiplier = (widget.height - _barLabelHeight) / maxYValue;
    final _halfAverageLineHeight = _averageLineHeight / 2;
    return _barLabelHeight +
        (multiplier * averageValue) -
        _halfAverageLineHeight;
  }
}

class GraphGrid extends StatelessWidget {
  const GraphGrid(this.numberOfBars, this.barLabelHeight, {super.key});

  final int numberOfBars;
  final double barLabelHeight;
  final double strokeWidth = 0.4;
  final double dashSize = 2.5;
  final double dashSpace = 1.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          bottom: barLabelHeight,
          child: CustomPaint(
            painter: GridPainter(
              numberOfBars: numberOfBars,
              spacing: strokeWidth + dashSpace,
            ),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final int numberOfBars;
  final double spacing;

  GridPainter({required this.numberOfBars, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;

    // horizontal line
    double startX = 0;
    double endX = size.width;
    double dashWidth = 2;
    double dashSpace = 2;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, size.height - 24),
        Offset(startX + dashWidth, size.height - 24),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Bar properties
    double barWidth = 35.0; // Width of a bar
    double totalUsableWidth = size.width - (numberOfBars * barWidth);
    double spaceBetweenBars = totalUsableWidth / (numberOfBars + 1);

    // Calculate bar positions
    List<double> barPositions = List.generate(numberOfBars, (index) {
      return spaceBetweenBars + (index * (barWidth + spaceBetweenBars));
    });

    for (int i = 0; i < numberOfBars - 1; i++) {
      double x = barPositions[i] + barWidth + (spaceBetweenBars / 2);
      double y = -20; // top height

      while (y < size.height - 1) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + dashWidth),
          paint,
        );
        y += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarLabel extends StatelessWidget {
  const BarLabel({
    super.key,
    required this.label,
    required this.subLabel,
  });

  final String? label;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 9),
        Text(
          label ?? '',
          style: AppTextStyles.gilroyRegular.copyWith(
              color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        // const SizedBox(height: 2),
        // if (subLabel != null)
        //   Text(
        //     subLabel!,
        //     style: const TextStyle(
        //       color: Colors.white,
        //       fontSize: 8,
        //     ),
        //   ),
      ],
    );
  }
}

class AverageLine extends StatelessWidget {
  const AverageLine({
    super.key,
    this.averageLabel,
    required this.numberOfBars,
  });

  final String? averageLabel;
  final int numberOfBars;

  @override
  Widget build(BuildContext context) {
    if (numberOfBars <= 1) return const SizedBox.shrink();

    return Container(
      height: 1,
      color: Colors.green,
      child: averageLabel != null
          ? Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.green,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  averageLabel!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 9,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _BarTooltips extends StatelessWidget {
  const _BarTooltips({
    required this.numberOfBars,
    required this.dataPoints,
    required this.barGraphHeight,
    required this.barLabelHeight,
    required this.maxYValue,
    required this.selectedIndex,
    required this.tooltipHeight,
  });

  final int numberOfBars;
  final List<MoneyBarGraphDataPointVm> dataPoints;
  final double barGraphHeight;
  final double barLabelHeight;
  final double maxYValue;
  final int selectedIndex;
  final double tooltipHeight;

  @override
  Widget build(BuildContext context) {
    if (numberOfBars == 0) return const SizedBox.shrink();

    return Row(
      children: List.generate(numberOfBars, (index) {
        //  final data = dataPoints.getOrNull(index);

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (selectedIndex == index)
                  ? Stack(
                      children: [
                        //  Positioned.fill(
                        //    child: CredAsset(
                        //      url: Assets.svg.icMoneyDownTooltip,
                        //      type: AssetType.svg,
                        //      storageType: AssetStorageType.asset,
                        //      fit: BoxFit.fill,
                        //      showDefaultPlaceholder: false,
                        //    ),
                        //  ),
                        //  Padding(
                        //    padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 14),
                        //    child: FittedBox(
                        //      fit: BoxFit.scaleDown,
                        //      child: CustomRichText(
                        //        text: data?.yLabel,
                        //        textStyle: LightHeadings.b10.popBlack_500.getTabularFiguresFontFeatures(),
                        //      ),
                        //    ),
                        //  ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
              //  SizedBox(
              //    height: getBarHeight(maxYValue: maxYValue, barValue: data?.yValue ?? 0),
              //  ),
            ],
          ),
        );
      }),
    );
  }

  double getBarHeight({required double maxYValue, required double barValue}) {
    final multiplier = (barGraphHeight - barLabelHeight) / maxYValue;
    return multiplier * barValue;
  }
}
