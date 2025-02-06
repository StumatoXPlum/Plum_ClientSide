import 'package:flutter/material.dart';
import 'package:task1/presentation/views/streak_screen.dart';
import 'package:task1/presentation/views/bar_graph_screen.dart';
import 'package:task1/presentation/views/recurring_payment_screen.dart';
import 'package:task1/presentation/views/pie_chart_screen.dart';
import 'package:task1/presentation/viewmodels/bar_graph_vm.dart';
import 'package:task1/presentation/dummy%20data/dummy_bar_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Screens Demo',
      debugShowCheckedModeBanner: false,
      home: const CombinedHomeScreen(),
    );
  }
}


class CombinedHomeScreen extends StatelessWidget {
  const CombinedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Combined Screens'),
        backgroundColor: Colors.black,
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              SizedBox(
                height: 250,
                child: const StreakScreen(),
              ),
              const SizedBox(height: 20),


              SizedBox(
                height: 300,
                child: BarGraphScreen(
                  graphVm: DummyBarData.getMockData(),
                  onBarTap: (index, tapped) {
                    debugPrint("Bar tapped: index = $index, tapped = $tapped");
                  },
                ),
              ),
              const SizedBox(height: 20),


              SizedBox(
                height: 250,
                child: RecurringPaymentScreen(
                  type: 'Subscription',
                  amount: '₹6,700',
                  date: '02 AUG',
                  onCheckNowPressed: () {
                    debugPrint("Recurring payment button pressed");
                  },
                ),
              ),
              const SizedBox(height: 20),


              SizedBox(
                height: 270,
                child: const PieChartScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
