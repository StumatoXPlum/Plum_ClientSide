import 'dart:convert';

class ReportModel {
  final String id;
  final List<String> media;
  final String title;
  final String date;
  final String subtitle;
  final String description;

  const ReportModel({
    required this.id,
    required this.media,
    required this.title,
    required this.date,
    required this.subtitle,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': jsonEncode(media),
      'title': title,
      'date': date,
      'subtitle': subtitle,
      'description': description,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];
    final imageField = json['image'];
    if (imageField != null) {
      if (imageField is String && imageField.startsWith("[")) {
        final decoded = jsonDecode(imageField);
        if (decoded is List) {
          imageList = decoded.map((e) => e.toString()).toList();
        }
      } else if (imageField is List) {
        imageList = imageField.map((e) => e.toString()).toList();
      }
    }

    return ReportModel(
      id: json['id'] ?? '',
      media: imageList,
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static List<ReportModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((item) => item is Map<String, dynamic>)
        .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
