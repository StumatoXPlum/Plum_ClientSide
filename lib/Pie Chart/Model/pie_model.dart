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
