import 'package:task1/Pie%20Chart/View%20Model/pie_chart_vm.dart';

class PieModel {
  final String category;
  final String amount;

  PieModel({
    required this.category,
    required this.amount,
  });

  factory PieModel.fromJson(Map<String, dynamic> json) {
    return PieModel(
      category: json['category'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
    };
  }
}

class DummyPieData {
  static ForegroundWidgetVm getPieData() => ForegroundWidgetVm(
      header: 'AMOUNT SPENT ON TRANSPORTATION',
      amount: '11,250',
      amountSub: '.00',
      buttonText: 'VIEW CASH FLOW');
}
