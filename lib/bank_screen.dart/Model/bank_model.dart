class BankModel {
  final String title;
  final String amount;
  final String bankName;
  final String lastDigits;
  final String ctaText;
  final List<InterestSection> sections;

  BankModel({
    required this.title,
    required this.amount,
    required this.bankName,
    required this.lastDigits,
    required this.ctaText,
    required this.sections,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      title: json['interest_earned']['title'] as String,
      amount: json['interest_earned']['amount'] as String,
      bankName: json['interest_earned']['bank_name'] as String,
      lastDigits: json['interest_earned']['last_digits'] as String,
      ctaText: json['interest_earned']['cta']['label'] as String,
      sections: (json['interest_earned']['sections'] as List)
          .map((section) => InterestSection.fromJson(section))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'bank_name': bankName,
      'last_digits': lastDigits,
      'ctaText': ctaText,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

class InterestSection {
  final String header;
  final String category;
  final String amount;
  final String icon;

  InterestSection({
    required this.header,
    required this.category,
    required this.amount,
    required this.icon,
  });

  factory InterestSection.fromJson(Map<String, dynamic> json) {
    return InterestSection(
      header: json['header'] as String,
      category: json['category'] as String,
      amount: json['amount'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header': header,
      'category': category,
      'amount': amount,
      'icon': icon,
    };
  }
}


