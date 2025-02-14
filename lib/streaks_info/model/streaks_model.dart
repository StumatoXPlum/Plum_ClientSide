class StreaksModel {
  final String title;
  final String ctaText;
  final List<StreaksCard> cardData;

  StreaksModel({
    required this.title,
    required this.ctaText,
    required this.cardData,
  });
}

class StreaksCard {
  final String title;
  final String iconUrl;
  final String subtitle;
  final String amount;
  final String logo;

  StreaksCard({
    required this.title,
    required this.iconUrl,
    required this.subtitle,
    required this.amount,
    required this.logo,
  });

  factory StreaksCard.fromJson(Map<String, dynamic> json) {
    return StreaksCard(
      title: json['title'] as String,
      iconUrl: json['iconUrl'] as String,
      subtitle: json['subtitle'] as String,
      amount: json['amount'] as String,
      logo: json['logo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'iconUrl': iconUrl,
      'subtitle': subtitle,
      'amount': amount,
      'logo': logo,
    };
  }
}
