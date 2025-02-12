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
