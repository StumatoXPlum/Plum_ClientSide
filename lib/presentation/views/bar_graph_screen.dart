import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/presentation/viewmodels/bar_graph_vm.dart';

class BarGraphScreen extends StatefulWidget {
  const BarGraphScreen({
    super.key,
    required this.graphVm,
    this.onBarTap,
  });

  final MoneyBarGraphVm graphVm;
  final void Function(int, bool)? onBarTap;

  @override
  State<BarGraphScreen> createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
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
    return Scaffold(
      body: Container(
        // height: 300,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 15,
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
                      style: AppTextStyles.dentonBold.copyWith(
                          fontSize: 24, color: Colors.white, height: 1.7),
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
                            "VIEW CASH FLOW",
                            style: AppTextStyles.gilroyBold.copyWith(
                              fontSize: 10,
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
              ),
              Padding(
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
                                    if (value.toInt() >=
                                        widget.graphVm.numberOfBars) {
                                      return Text(
                                        '',
                                      );
                                    }
                                    return BarLabel(
                                      label: widget.graphVm
                                          .dataPoints[value.toInt()].xLabel,
                                      subLabel: widget.graphVm
                                          .dataPoints[value.toInt()].xSubLabel,
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
                                    toY:
                                        widget.graphVm.dataPoints[index].yValue,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
