import 'package:flutter/material.dart';
import 'package:task1/screens/bar_graph_screen.dart';
import 'package:task1/view%20model/bar_graph_vm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: BarGraphScreen(
        graphVm: MoneyBarGraphVm(
          dataPoints: [
            MoneyBarGraphDataPointVm(
                xLabel: "APR", yValue: 500, yLabel: "\$500"),
            MoneyBarGraphDataPointVm(
                xLabel: "MAY", yValue: 700, yLabel: "\$700"),
            MoneyBarGraphDataPointVm(
                xLabel: "JUN", yValue: 700, yLabel: "\$300"),
            MoneyBarGraphDataPointVm(
                xLabel: "JUL", yValue: 900, yLabel: "\$900"),
            MoneyBarGraphDataPointVm(
                xLabel: "AUG", yValue: 900, yLabel: "\$900"),
          ],
          selectedBarIndex: 1,
          maxYAxisValue: 800,
          averageValue: 600,
          averageLabel: "Avg: ₹600",
        ),
        onBarTap: (index, isSelected) {
          print("Bar $index tapped, isSelected: $isSelected");
        },
      ),
    );
  }
}
