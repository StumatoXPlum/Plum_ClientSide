class StreaksModel {
  final String type;
  final String amount;
  final String streakCount;

  StreaksModel({
    required this.type,
    required this.amount,
    required this.streakCount,
  });

  factory StreaksModel.fromJson(Map<String, dynamic> json) {
    return StreaksModel(
      type: json['type'] as String,
      amount: json['amount'] as String,
      streakCount: json['streak_count'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'streak_count': streakCount,
    };
  }
}
