class BarModel {
  final String amount;

  BarModel({
    required this.amount,
  });

  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
    };
  }
}
