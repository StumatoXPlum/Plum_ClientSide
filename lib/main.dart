import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task1/Streaks/View/streak_screen.dart';
import 'package:task1/Bar%20Graph/View/bar_graph_screen.dart';
import 'package:task1/Recurring/View/recurring_payment_screen.dart';
import 'package:task1/Pie%20Chart/View/pie_chart_screen.dart';
import 'package:task1/Tag%20Trans/tag_transaction.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Screens Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
                child: StreakScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: const BarGraphScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: RecurringPaymentScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: PieChartScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: const TagTransaction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
