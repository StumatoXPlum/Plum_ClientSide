import 'package:task1/bank_screen.dart/Model/bank_model.dart';

class BankVm {
  final String title;
  final String amount;
  final String bankName;
  final String lastDigits;
  final String ctaText;
  final List<InterestSection> sections;

  const BankVm({
    required this.title,
    required this.amount,
    required this.bankName,
    required this.lastDigits,
    required this.ctaText,
    required this.sections,
  });

  factory BankVm.fromModel(BankModel model) {
    return BankVm(
      title: model.title,
      amount: model.amount,
      bankName: model.bankName,
      lastDigits: model.lastDigits,
      ctaText: model.ctaText,
      sections: model.sections,
    );
  }
}

class BankVM {
  BankModel getBankData() {
    return 
      BankModel(
        title: "PROJECTED INTEREST \nFOR JAN-MAR",
        amount: "450.00",
        bankName: "Axis Bank",
        lastDigits: "6782",
        ctaText: "VIEW BALANCE",
        sections: [
          InterestSection(
            header: "Interest Earned",
            category: "Interest",
            amount: "1700",
            icon: "+",
          ),
          InterestSection(
            header: "Savings Interest",
            category: "Savings",
            amount: "500",
            icon: "+",
          ),
          InterestSection(
            header: "Investment Returns",
            category: "Investment",
            amount: "2000",
            icon: "+",
          ),
        ],
      );
  }
}
