import 'package:flutter/material.dart';
import 'package:task1/Utils/fonts/fonts.dart';
import 'package:task1/presentation/viewmodels/pie_chart_vm.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;

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
                      style: AppTextStyles.gilroyBold.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
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
                      width: screenWidth * 0.32,
                      padding:
                          EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 1),
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
                            style: AppTextStyles.gilroyBold.copyWith(
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              height: 2,
                              letterSpacing: 1.4,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 18,
                          )
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
