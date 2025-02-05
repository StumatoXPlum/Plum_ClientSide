class StreaksModel {
  final String type;
  final String amount;
  final String streakCount;
  final String investmentCount;
  final String monthCount;

  StreaksModel({
    required this.type,
    required this.amount,
    required this.streakCount,
    required this.investmentCount,
    required this.monthCount,
  });

  factory StreaksModel.fromJson(Map<String, dynamic> json) {
    return StreaksModel(
      type: json['type'] as String,
      amount: json['amount'] as String,
      streakCount: json['streak_count'] as String,
      investmentCount: json['investment_count'] as String,
      monthCount: json['month_count'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'streak_count': streakCount,
      'investment_count': investmentCount,
      'month_count': monthCount,
    };
  }
}
