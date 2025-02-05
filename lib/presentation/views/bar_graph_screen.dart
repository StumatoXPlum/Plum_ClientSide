import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/presentation/dummy%20data/dummy_bar_data.dart';
import 'package:task1/presentation/viewmodels/bar_graph_vm.dart';

class BarGraphScreen extends StatelessWidget {
  const BarGraphScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 270,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Stack(
            children: [
              Positioned(
                right: -5,
                child: BarGraphWidget(
                  graphVm: DummyBarData.getMockData(),
                ),
              ),
              Positioned(
                top: 50,
                child: ForeGroundData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForeGroundData extends StatelessWidget {
  const ForeGroundData({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "INVESTMENTS ARE HIGHER\nTHAN LAST MONTH",
            style: AppTextStyles.gilroyBold.copyWith(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
            maxLines: 2,
          ),
          Text(
            "₹11,00,250.00",
            style: AppTextStyles.dentonBold
                .copyWith(fontSize: 24, color: Colors.white, height: 1.7),
          ),
          Container(
            width: screenWidth * 0.32,
            padding: EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 1),
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
                  "VIEW CASH FLOW",
                  style: AppTextStyles.gilroyBold.copyWith(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    letterSpacing: 1.4,
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
    );
  }
}

class BarGraphWidget extends StatefulWidget {
  const BarGraphWidget({
    super.key,
    required this.graphVm,
    this.onBarTap,
  });

  final MoneyBarGraphVm graphVm;
  final void Function(int, bool)? onBarTap;

  @override
  State<BarGraphWidget> createState() => _BarGraphWidgetState();
}

class _BarGraphWidgetState extends State<BarGraphWidget> {
  final double _barWidth = 18;
  final double _barLabelHeight = 36;
  final List<Color> customColors = [
    Color(0xFF0E0C0C),
    Color(0xFF181817),
    Color(0xFF252422),
    Color(0xFF262523),
    Color(0xFFF3F2F3),
  ];

  final List<Color> barLabelColors = [
    Colors.grey[600]!,
    Colors.grey[500]!,
    Colors.grey[400]!,
    Colors.grey[300]!,
    Colors.white
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: SizedBox(
        width: 180, //chart height/wdith
        height: 150,
        child: Stack(
          children: [
            GraphGrid(
              widget.graphVm.numberOfBars,
              _barLabelHeight,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: widget.graphVm.maxYAxisValue,
                  minY: 0,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= widget.graphVm.numberOfBars) {
                            return Text(
                              '',
                            );
                          }
                          return BarLabel(
                            label:
                                widget.graphVm.dataPoints[value.toInt()].xLabel,
                            subLabel: widget
                                .graphVm.dataPoints[value.toInt()].xSubLabel,
                            color: barLabelColors[value.toInt()],
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    widget.graphVm.numberOfBars,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: widget.graphVm.dataPoints[index].yValue,
                          width: _barWidth,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(0)),
                          color: customColors[index],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
