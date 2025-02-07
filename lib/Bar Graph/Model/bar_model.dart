///data model for bar graph
class BarModel {
  final String amount;
  final String xLabel;
  final double yValue;

  BarModel({
    required this.amount,
    required this.xLabel,
    required this.yValue,
  });

  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
      amount: json['amount'],
      xLabel: json['xLabel'],
      yValue: json['yValue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'xLabel': xLabel,
      'yValue': yValue,
    };
  }
}
