
import 'package:task1/new_bar_graph/view_model/new_bar_vm.dart';

class BarModel {
  final String title;
  final String xLabel;
  final double yValue;
  final String ctaText;

  BarModel({
    required this.title,
    required this.xLabel,
    required this.yValue,
    required this.ctaText,
  });

  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
        title: json['title'],
        xLabel: json['xLabel'],
        yValue: json['yValue']?.toDouble() ?? 0.0,
        ctaText: json['cta_text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'xLabel': xLabel,
      'yValue': yValue,
      'cta_text': ctaText,
    };
  }
}

// dummy data

class NewDummyBarData {
  static NewBarVm getMockGraphData() {
    return NewBarVm(
      dataPoints: [
        NewMoneyBarGraphDataPointVm(
            xLabel: "APR", yValue: 500, yLabel: "\$500"),
        NewMoneyBarGraphDataPointVm(
            xLabel: "MAY", yValue: 700, yLabel: "\$700"),
        NewMoneyBarGraphDataPointVm(
            xLabel: "JUN", yValue: 300, yLabel: "\$300"),
        NewMoneyBarGraphDataPointVm(
            xLabel: "JUL", yValue: 900, yLabel: "\$900"),
        NewMoneyBarGraphDataPointVm(
            xLabel: "AUG", yValue: 900, yLabel: "\$900"),
      ],
      selectedBarIndex: 1,
      maxYAxisValue: 800,
      averageValue: 600,
      averageLabel: "AVG 1.5K",
    );
  }

  static NewForegroundDataVm getMockForegroundData() {
    return NewForegroundDataVm(
      title: 'refunds received in \nthe last 6 months',
      ctaText: 'VIEW CASHFLOW',
    );
  }
}
