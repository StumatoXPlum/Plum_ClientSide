import 'package:flutter/material.dart';
import 'package:task1/screens/bar_graph_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final data = [
    BarData(month: 'APR', value: 60),
    BarData(month: 'MAY', value: 65),
    BarData(month: 'JUNE', value: 70),
    BarData(month: 'JULY', value: 85),
    BarData(month: 'AUG', value: 100),
  ];
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: BarGraphScreen(
        data: data,
        width: 300,
        height: 200,
        onBarTap: (index) {
          print('Tapped bar at index: $index');
        },
      ),
    );
  }
}
