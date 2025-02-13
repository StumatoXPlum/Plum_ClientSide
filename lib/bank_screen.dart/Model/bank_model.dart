import 'package:task1/bank_screen.dart/view%20modal/bank_vm.dart';

class BankModel {
  final String title;
  final String type;
  final String amount;
  final String interestAmount;
  final String bankName;
  final String lastDigits;
  final String ctaText;

  BankModel(
      {required this.title,
      required this.type,
      required this.amount,
      required this.interestAmount,
      required this.bankName,
      required this.lastDigits,
      required this.ctaText});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      title: json['title'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      interestAmount: json['interest_amount'] as String,
      bankName: json['bank_Name'] as String,
      lastDigits: json['last_digits'] as String,
      ctaText: json['ctaText'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'interest_amount': interestAmount,
      'ctaText': ctaText,
    };
  }
}


class DummyinterestData {
  static List<BankVm> getDummyInterestData() => [
        BankVm(
          title: 'INTEREST EARNED \nHAS CROSSED',
          type: 'Interest',
          amount: '450.00',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
        BankVm(
          title: 'investments have an \nmonth streak',
          type: 'Shopping',
          amount: '1,700',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
        BankVm(
          title: 'investments have an \nmonth streak',
          type: 'Rent',
          amount: '5,700',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
      ];
}
