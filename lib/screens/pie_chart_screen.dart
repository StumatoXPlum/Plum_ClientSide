import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts.dart';
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
      body: Container(
        height: 270,
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
                    Text(
                      "AMOUNT SPENT ON\nTRANSPORTATION",
                      style: AppTextStyles.gilroyRegular.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹11,250.00",
                      style: AppTextStyles.dentonBold.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                          Icon(Icons.keyboard_arrow_right_outlined)
                        ],
                      ),
                    )
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
    );
  }
}
