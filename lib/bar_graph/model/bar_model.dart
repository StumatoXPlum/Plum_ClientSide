class BarModel {
  final String xLabel;
  final String? xSubLabel;
  final double? xValue;
  final String yLabel;
  final String? yElaborateLabel;
  final double yValue;
  final bool isSelected;

  BarModel({
    required this.xLabel,
    this.xSubLabel,
    this.xValue,
    required this.yLabel,
    this.yElaborateLabel,
    required this.yValue,
    required this.isSelected,
  });

  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
      xLabel: json['x_label'],
      xSubLabel: json['x_sub_label'],
      xValue: (json['x_value'] as num?)?.toDouble(),
      yLabel: json['y_label'],
      yElaborateLabel: json['y_elaborate_label'],
      yValue: (json['y_value'] as num).toDouble(),
      isSelected: json['is_selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x_label': xLabel,
      'x_sub_label': xSubLabel,
      'x_value': xValue,
      'y_label': yLabel,
      'y_elaborate_label': yElaborateLabel,
      'y_value': yValue,
      'is_selected': isSelected,
    };
  }
}
