import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts.dart';
import 'package:task1/view%20model/bar_graph_vm.dart';

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
                      style: AppTextStyles.gilroyRegular.copyWith(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
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
                            style: AppTextStyles.gilroyRegular.copyWith(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              height: 2,
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
                                    color: Color.fromRGBO(
                                      255,
                                      255,
                                      255,
                                      0.2 +
                                          ((index /
                                                  (widget.graphVm.numberOfBars -
                                                      1)) *
                                              0.9),
                                    ),
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
