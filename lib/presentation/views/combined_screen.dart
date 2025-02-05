import 'package:flutter/material.dart';
import 'package:task1/presentation/views/bar_graph_screen.dart';
import 'package:task1/presentation/views/pie_chart_screen.dart';
import 'package:task1/presentation/views/recurring_payment_screen.dart';
import 'package:task1/presentation/views/streak_screen.dart';

class CombinedScreen extends StatelessWidget {
  const CombinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 300, child: PieChartScreen()),
              SizedBox(
                  height: 300,
                  child: BarGraphScreen()),
              SizedBox(height: 300, child: StreakScreen()),
              SizedBox(height: 300, child: RecurringPaymentScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
