import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraphScreen extends StatefulWidget {
  const BarGraphScreen(
      {super.key,
      required this.data,
      this.onBarTap,
      required this.width,
      required this.height});

  final List<BarData> data;
  final Function(int)? onBarTap;
  final double width;
  final double height;

  @override
  State<BarGraphScreen> createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  final double barWidth = 18;
  final double barLabelHeight = 36;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "INVESTMENTS ARE HIGHER\nTHAN LAST MONTH",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Text(
                          "₹1,250.00",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_right_alt),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          onPressed: () {},
                          label: const Text("VIEW CASH FLOW"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: Container(
                      width: 180,
                      height: 150,
                      color: Colors.black,
                      child: Stack(
                        children: [
                          // Grid lines
                          Positioned.fill(
                            child: CustomPaint(
                              painter: GridPainter(
                                numberOfBars: widget.data.length,
                                spacing:
                                    widget.width / (widget.data.length + 1),
                              ),
                            ),
                          ),

                          // Bar Chart
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 80,
                                minY: 0,
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >=
                                            widget.data.length) {
                                          return const Text('');
                                        }
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            widget.data[value.toInt()].month,
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                255, // Red (white)
                                                255, // Green (white)
                                                255, // Blue (white)
                                                0.3 +
                                                    ((value /
                                                            (widget.data
                                                                    .length -
                                                                1)) *
                                                        0.7), 
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                barGroups: List.generate(
                                  widget.data.length,
                                  (index) => BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: widget.data[index].value,
                                        width: barWidth,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(0)),
                                        color: Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.3 +
                                              ((index /
                                                      (widget.data.length -
                                                          1)) *
                                                  0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchCallback: (event, response) {
                                    if (event is FlTapUpEvent &&
                                        response?.spot != null) {
                                      setState(() {
                                        selectedIndex = response!
                                            .spot!.touchedBarGroupIndex;
                                      });
                                      widget.onBarTap?.call(selectedIndex);
                                    }
                                  },
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
        ],
      ),
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

    // draw horizontal bottom dotted line
    double startX = 0;
    double endX = size.width;
    double dashWidth = 2;
    double dashSpace = 2;

    // horizontal bottom line
    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, size.height - 60),
        Offset(startX + dashWidth, size.height - 60),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Calculate positions for 5 bars
    double barWidth = 35.0; // Width o bar
    double totalUsableWidth =
        size.width - (barWidth * 5); // Width available for spacing
    double spaceBetweenBars = totalUsableWidth /
        6; // Divide remaining space into 6 parts (5 bars need 6 spaces)

    // Calculate starting position of each bar
    List<double> barPositions = List.generate(5, (index) {
      return spaceBetweenBars + (index * (barWidth + spaceBetweenBars));
    });

    for (int i = 0; i < 4; i++) {
      // Calculate center pt.
      double x = barPositions[i] + barWidth + (spaceBetweenBars / 2);
      double y = -25; // vertical dotted line height

      while (y < size.height - 35) {
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + 2),
          paint,
        );
        y += 4;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Data model for bar chart
class BarData {
  final String month;
  final double value;

  BarData({required this.month, required this.value});
}

