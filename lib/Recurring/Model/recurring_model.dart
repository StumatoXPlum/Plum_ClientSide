class RecurringModel {
  final String count;
  final String type;
  final String amount;
  final String date;

  RecurringModel({
    required this.count,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory RecurringModel.fromJson(Map<String, dynamic> json) {
    return RecurringModel(
      count: json['count'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'type': type,
      'amount': amount,
      'date': date,
    };
  }
}

