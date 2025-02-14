import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task1/new_bar_graph/view/new_bar_graph.dart';
import 'package:task1/recurring_info/view_model/recurring_vm.dart';
import 'package:task1/streaks_info/view/streak_screen.dart';
import 'package:task1/bar_graph/view/bar_graph_screen.dart';
import 'package:task1/recurring_info/view/recurring_payment_screen.dart';
import 'package:task1/pie_chart/view/pie_chart_screen.dart';
import 'package:task1/streaks_info/view_model/streaks_vm.dart';
import 'package:task1/tag_trans_info/view/tag_transaction.dart';
import 'package:task1/bank_screen.dart/view_modal/bank_vm.dart';
import 'package:task1/bank_screen.dart/view/bank_screen.dart';

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
                child: StreakScreen(
                  streaksVM: DummyStreaksData(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: const BarGraphScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: RecurringPaymentScreen(
                  recurringVM: DummyRecurringData(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: PieChartScreen(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: TagTransaction(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: BankScreen(
                  bankVM: BankVM(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 270,
                child: NewBarGraph(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
