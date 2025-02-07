import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task1/Bar%20Graph/ViewModel/bar_graph_vm.dart';

import '../Model/dummy_bar_data.dart';

/// This is your complete screen widget.
class BarGraphScreen extends StatelessWidget {
  const BarGraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final graphVm = DummyBarData.getMockGraphData();
    final foregroundData = DummyBarData.getMockForegroundData();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Stack(
            children: [
              Positioned(
                left: 1,
                bottom: 80,
                child: ForegroundDataWidget(data: foregroundData),
              ),
              Positioned(
                right: 1,
                bottom: 70,
                child: MoneyBarGraph(
                  graphVm: graphVm,
                  width: 170,
                  height: 110,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoneyBarGraph extends StatefulWidget {
  const MoneyBarGraph({
    Key? key,
    required this.graphVm,
    required this.width,
    required this.height,
    this.onBarTap,
  }) : super(key: key);

  final MoneyBarGraphVm graphVm;
  final void Function(int, bool)? onBarTap;
  final double width;
  final double height;

  @override
  State<MoneyBarGraph> createState() => _MoneyBarGraphState();
}

class _MoneyBarGraphState extends State<MoneyBarGraph> {
  final double _barWidth = 20;
  final double _barLabelHeight = 36;
  final double _averageLineHeight = 16;
  final double _barTooltipHeight = 22;
  int animationDuration = 500;

  late int _selectedIndex;
  bool _shouldAnimateFast = false;
  bool _shouldAnimate = true;

  final List<Color> customColors = [
    const Color(0xFF0E0C0C),
    const Color(0xFF181817),
    const Color(0xFF252422),
    const Color(0xFF262523),
    const Color(0xFFF3F2F3),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.graphVm.selectedBarIndex;
    widget.onBarTap?.call(_selectedIndex, false);
  }

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

  double getAverageLinePosition(
      {required double maxYValue, required double averageValue}) {
    final multiplier = (widget.height - _barLabelHeight) / maxYValue;
    final halfAverageLineHeight = _averageLineHeight / 2;
    return _barLabelHeight +
        (multiplier * averageValue) -
        halfAverageLineHeight;
  }

  @override
  Widget build(BuildContext context) {
    final maxYValue = widget.graphVm.maxYAxisValue;
    final numberOfBars = widget.graphVm.numberOfBars;

    return SizedBox(
      width: widget.width,
      height: widget.height + _barTooltipHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: _barTooltipHeight,
            bottom: -40,
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
                barGroups: List.generate(
                  widget.graphVm.numberOfBars,
                  (index) => BarChartGroupData(
                    x: index,
                    barsSpace: 14,
                    barRods: [
                      BarChartRodData(
                        toY: widget.graphVm.dataPoints[index].yValue,
                        width: _barWidth,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(0)),
                        color: customColors[index % customColors.length],
                      ),
                    ],
                  ),
                ),
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.center,
                gridData: const FlGridData(show: false),
                maxY: maxYValue,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= widget.graphVm.numberOfBars) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: BarLabel(
                            label: widget.graphVm.dataPoints[index].xLabel,
                            subLabel:
                                widget.graphVm.dataPoints[index].xSubLabel,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
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
          // if (widget.graphVm.averageValue != null)
          //   Positioned(
          //     bottom: getAverageLinePosition(
          //         maxYValue: maxYValue,
          //         averageValue: widget.graphVm.averageValue!),
          //     left: 0,
          //     right: 0,
          //     height: _averageLineHeight,
          //     child: AverageLine(
          //       averageLabel: widget.graphVm.averageLabel,
          //       numberOfBars: numberOfBars,
          //     ),
          //   ),
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
}

class GraphGrid extends StatelessWidget {
  const GraphGrid(this.numberOfBars, this.barLabelHeight, {Key? key})
      : super(key: key);

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

/// The [CustomPainter] that draws the dashed grid lines.
class GridPainter extends CustomPainter {
  final int numberOfBars;
  final double spacing;

  GridPainter({required this.numberOfBars, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;

    // Draw horizontal dashed line.
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

    double barWidth = 35.0; // assumed bar width
    double totalUsableWidth = size.width - (numberOfBars * barWidth);
    double spaceBetweenBars = totalUsableWidth / (numberOfBars + 1);

    List<double> barPositions = List.generate(numberOfBars, (index) {
      return spaceBetweenBars + (index * (barWidth + spaceBetweenBars));
    });

    for (int i = 0; i < numberOfBars - 1; i++) {
      double x = barPositions[i] + barWidth + (spaceBetweenBars / 2);
      double y = -20;
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

/// widget to display the x-axis labels.
class BarLabel extends StatelessWidget {
  BarLabel({
    super.key,
    required this.label,
    required this.subLabel,
    required this.index,
  });

  final String? label;
  final String? subLabel;
  final int index;
  final List<Color> monthColors = [
    Colors.white10,
    Colors.white30,
    Colors.white38,
    Colors.white54,
    Colors.white70,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label ?? '',
          style: TextStyle(
            color: monthColors[index % monthColors.length],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subLabel != null)
          Text(
            subLabel!,
            style: TextStyle(
              color: monthColors[index % monthColors.length],
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}

/// widget to show the average line and its label.
class AverageLine extends StatelessWidget {
  const AverageLine({
    Key? key,
    this.averageLabel,
    required this.numberOfBars,
  }) : super(key: key);

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

/// (currently minimal) widget for custom tooltips.
class _BarTooltips extends StatelessWidget {
  const _BarTooltips({
    Key? key,
    required this.numberOfBars,
    required this.dataPoints,
    required this.barGraphHeight,
    required this.barLabelHeight,
    required this.maxYValue,
    required this.selectedIndex,
    required this.tooltipHeight,
  }) : super(key: key);

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
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (selectedIndex == index)
                  ? Stack(
                      children: [],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 8),
            ],
          ),
        );
      }),
    );
  }
}

/// A widget that displays the overlay “foreground” data.
/// All text is provided via the [ForegroundDataVm] so no hard-coded strings appear here.
class ForegroundDataWidget extends StatelessWidget {
  final ForegroundDataVm data;
  const ForegroundDataWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.header,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.51,
            letterSpacing: 1.61,
            color: Color(0xB3FFFFFF),
          ),
          textAlign: TextAlign.start,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: data.amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Denton',
                  fontWeight: FontWeight.w700,
                  height: 1.71,
                  letterSpacing: 0.12,
                ),
              ),
              TextSpan(
                text: data.amountSub,
                style: const TextStyle(
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
          textAlign: TextAlign.center,
        ),
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
                data.actionText,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
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
