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
    const Color(0xFF0E0C0C),
    const Color(0xFF181817),
    const Color(0xFF252422),
    const Color(0xFF262523),
    const Color(0xFFF3F2F3),
  ];

  final List<Color> barLabelColors = [
    Colors.grey[600]!,
    Colors.grey[500]!,
    Colors.grey[400]!,
    Colors.grey[300]!,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 172,
                      height: 42,
                      child: Text(
                        'INVESTMENTS ARE HIGHER\nTHAN LAST MONTH',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700, // 700 Bold weight
                          height: 1.51,
                          letterSpacing: 1.61,
                          color: Color(0xB3FFFFFF),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),


                    const SizedBox(height: 15),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '₹1,00,250',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Denton',
                              fontWeight: FontWeight.w700,
                              height: 1.71,
                              letterSpacing: 0.12,
                            ),
                          ),
                          TextSpan(
                            text: '.00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
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
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),
                                letterSpacing: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              size: 18,
                            ),
                          ],
                        ),

                    ),
                  ],
                ),
              ),
              // Right side: Bar chart area
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: SizedBox(
                  width: 180,
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
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= widget.graphVm.numberOfBars) {
                                      return const Text('');
                                    }
                                    return BarLabel(
                                      label: widget.graphVm.dataPoints[value.toInt()].xLabel,
                                      subLabel: widget.graphVm.dataPoints[value.toInt()].xSubLabel,
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
                                      top: Radius.circular(0),
                                    ),
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


class GraphGrid extends StatelessWidget {
  const GraphGrid(this.numberOfBars, this.barLabelHeight, {super.key});

  final int numberOfBars;
  final double barLabelHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          bottom: barLabelHeight,
          child: CustomPaint(
            painter: GridPainter(numberOfBars: numberOfBars),
          ),
        ),
      ],
    );
  }
}


class GridPainter extends CustomPainter {
  final int numberOfBars;

  GridPainter({required this.numberOfBars});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class BarLabel extends StatelessWidget {
  const BarLabel({
    super.key,
    required this.label,
    required this.subLabel,
    required this.color,
  });

  final String? label;
  final String? subLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Prevents overflow
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 5), // Adjusted for proper spacing
        Text(
          label ?? '',
          style: AppTextStyles.gilroyRegular.copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subLabel != null)
          Text(
            subLabel!,
            style: AppTextStyles.gilroyRegular.copyWith(
              color: color.withOpacity(0.7),
              fontSize: 8,
            ),
          ),
      ],
    );
  }
}
