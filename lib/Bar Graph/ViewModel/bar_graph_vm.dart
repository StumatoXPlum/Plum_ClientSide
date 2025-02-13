class MoneyBarGraphVm {
  final String title;
  final String ctaLabel;
  final String ctaAction;
  final double maxYAxisValue;
  final double averageValue;
  final String amount;
  final String amountSub;
  final String averageLabel;
  final int selectedBarIndex;
  final List<MoneyBarGraphDataPointVm> dataPoints;

  MoneyBarGraphVm({
    required this.title,
    required this.ctaLabel,
    required this.ctaAction,
    required this.maxYAxisValue,
    required this.averageValue,
    required this.amount,
    required this.amountSub,
    required this.averageLabel,
    required this.selectedBarIndex,
    required this.dataPoints,
  });

  factory MoneyBarGraphVm.fromJson(Map<String, dynamic> json) {
    final graphData = json['expanded_data']['graph_data'];
    return MoneyBarGraphVm(
      title: json['expanded_data']['title'],
      ctaLabel: json['expanded_data']['cta']['label'],
      ctaAction: json['expanded_data']['cta']['action'],
      amount: "₹11,250,",
      amountSub: "00",
      maxYAxisValue: (graphData['max_y_axis_value'] as num).toDouble(),
      averageValue: (graphData['average_value'] as num).toDouble(),
      averageLabel: graphData['average_label'],
      selectedBarIndex: graphData['selected_bar_index'] ?? 0,
      dataPoints: (graphData['data_points'] as List)
          .map((point) => MoneyBarGraphDataPointVm.fromJson(point))
          .toList(),
    );
  }
}

class MoneyBarGraphDataPointVm {
  final String xLabel;
  final String? xSubLabel;
  final double? xValue;
  final String yLabel;
  final String? yElaborateLabel;
  final double yValue;
  final bool isSelected;

  MoneyBarGraphDataPointVm({
    required this.xLabel,
    this.xSubLabel,
    this.xValue,
    required this.yLabel,
    this.yElaborateLabel,
    required this.yValue,
    required this.isSelected,
  });

  factory MoneyBarGraphDataPointVm.fromJson(Map<String, dynamic> json) {
    return MoneyBarGraphDataPointVm(
      xLabel: json['x_label'],
      xSubLabel: json['x_sub_label'],
      xValue: (json['x_value'] as num?)?.toDouble(),
      yLabel: json['y_label'],
      yElaborateLabel: json['y_elaborate_label'],
      yValue: (json['y_value'] as num).toDouble(),
      isSelected: json['is_selected'] ?? false,
    );
  }
}

/// view model “foreground” overlay text.
class ForegroundDataVm {
  final String header;
  final String amount;
  final String amountSub;
  final String actionText;

  ForegroundDataVm({
    required this.header,
    required this.amount,
    required this.amountSub,
    required this.actionText,
  });
}

final dummyGraphData = MoneyBarGraphVm(
  title: "refunds received \nin the last 6 months",
  ctaLabel: "VIEW CASHFLOW",
  ctaAction: "deeplink",
  amount: "₹11,250",
  amountSub: "00",
  maxYAxisValue: 800,
  averageValue: 600,
  averageLabel: "AVG ₹1.5K",
  selectedBarIndex: 1,
  dataPoints: [
    MoneyBarGraphDataPointVm(
      xLabel: "APR",
      xSubLabel: null,
      xValue: null,
      yLabel: "₹500",
      yElaborateLabel: null,
      yValue: 500,
      isSelected: false,
    ),
    MoneyBarGraphDataPointVm(
      xLabel: "MAY",
      xSubLabel: null,
      xValue: null,
      yLabel: "₹700",
      yElaborateLabel: null,
      yValue: 700,
      isSelected: false,
    ),
    MoneyBarGraphDataPointVm(
      xLabel: "JUN",
      xSubLabel: null,
      xValue: null,
      yLabel: "₹300",
      yElaborateLabel: null,
      yValue: 300,
      isSelected: false,
    ),
    MoneyBarGraphDataPointVm(
      xLabel: "JUL",
      xSubLabel: null,
      xValue: null,
      yLabel: "₹900",
      yElaborateLabel: null,
      yValue: 900,
      isSelected: false,
    ),
    MoneyBarGraphDataPointVm(
      xLabel: "AUG",
      xSubLabel: null,
      xValue: null,
      yLabel: "₹900",
      yElaborateLabel: null,
      yValue: 900,
      isSelected: false,
    ),
  ],
);
