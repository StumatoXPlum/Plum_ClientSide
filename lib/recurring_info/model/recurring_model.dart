class RecurringModel {
  final String title;
  final String ctaText;
  final List<RecurringCard> cardData;

  RecurringModel({
    required this.title,
    required this.ctaText,
    required this.cardData,
  });
}

class RecurringCard {
  final String title;
  final String subtitle;
  final String amount;
  final String logo;

  RecurringCard({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.logo,
  });

  factory RecurringCard.fromJson(Map<String, dynamic> json) {
    return RecurringCard(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      amount: json['amount'] as String,
      logo: json['logo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'logo': logo,
    };
  }
}
