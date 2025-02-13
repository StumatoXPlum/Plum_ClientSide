import 'package:task1/Streaks/View%20Modal/streaks_vm.dart';

class StreaksModel {
  final String title;
  final String type;
  final String amount;
  final String streakCount;
  final String investmentCount;
  final String monthCount;
  final String ctaText;

  StreaksModel({
required this.title,
    required this.type,
    required this.amount,
    required this.streakCount,
    required this.investmentCount,
    required this.monthCount,
    required this.ctaText
  });

  factory StreaksModel.fromJson(Map<String, dynamic> json) {
    return StreaksModel(
      title: json['type'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      streakCount: json['streak_count'] as String,
      investmentCount: json['investment_count'] as String,
      monthCount: json['month_count'] as String,
      ctaText: json['ctaText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'amount': amount,
      'streak_count': streakCount,
      'investment_count': investmentCount,
      'month_count': monthCount,
      'ctaText' : ctaText,
    };
  }
}



class DummyStreaksData {
  static List<StreaksVm> getDummyStreaksData() => [
        StreaksVm(
            title: 'subscriptions have \nbeen active for month.',
            type: 'Cook',
            amount: '₹6,700',
            streakCount: '3',
            investmentCount: '2',
            monthCount: '8',
            ctaText: 'VIEW RECURRING PAYMENTS'),
        StreaksVm(
            title: 'investments have an \nmonth streak',
            type: 'Shopping',
            amount: '₹1,700',
            streakCount: '2',
            investmentCount: '2',
            monthCount: '1',
            ctaText: 'Check Now'),
        StreaksVm(
            title: 'investments have an \nmonth streak',
            type: 'Rent',
            amount: '₹5,700',
            streakCount: '3',
            investmentCount: '2',
            monthCount: '4',
            ctaText: 'Check Now'),
      ];
}
