import 'package:flutter/material.dart';
import 'package:task1/view%20model/pie_chart_vm.dart';

class PieChartScreen extends StatelessWidget {
  const PieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<HomeVisualSectionItemVm> pieChartData = [
      HomeVisualSectionItemVm(percentage: 50.0),
      HomeVisualSectionItemVm(percentage: 30.0),
      HomeVisualSectionItemVm(percentage: 20.0),
      HomeVisualSectionItemVm(percentage: 30.0),
    ];

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
                          "AMOUNT SPENT ON\nTRANSPORTATION",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Text(
                          "₹11,250.00",
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
                  Expanded(
                    child: Center(
                      child: InAndOutPieGraph(
                        items: pieChartData,
                        onPieSectionTap: (index) {
                          print("Tapped:$index");
                        },
                        colorNumber: 2,
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
