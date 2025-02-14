class PieModel {
  final String title;
  final String amount;
  final Cta cta;
  final PieData pieData;

  PieModel({
    required this.title,
    required this.amount,
    required this.cta,
    required this.pieData,
  });

  factory PieModel.fromJson(Map<String, dynamic> json) {
    return PieModel(
      title: json['title'] as String,
      amount: json['amount'] as String,
      cta: Cta.fromJson(json['cta']),
      pieData: PieData.fromJson(json['graph_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'cta': cta.toJson(),
      'pie_data': pieData.toJson(),
    };
  }
}

class Cta {
  final String label;
  final String action;

  Cta({required this.label, required this.action});

  factory Cta.fromJson(Map<String, dynamic> json) {
    return Cta(
      label: json['label'] as String,
      action: json['action'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'action': action,
    };
  }
}

class PieData {
  final List<Section> sections;

  PieData({required this.sections});

  factory PieData.fromJson(Map<String, dynamic> json) {
    var list = json['sections'] as List;
    List<Section> sectionsList = list.map((i) => Section.fromJson(i)).toList();

    return PieData(sections: sectionsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}

class Section {
  final String category;
  final String amount;
  final double percentage;

  Section({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      category: json['category'] as String,
      amount: json['amount'] as String,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'percentage': percentage,
    };
  }
}
