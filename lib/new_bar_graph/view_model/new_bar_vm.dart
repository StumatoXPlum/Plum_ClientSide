class NewBarVm {
  final List<NewMoneyBarGraphDataPointVm> dataPoints;
  final int selectedBarIndex;
  final double maxYAxisValue;
  final double? averageValue;
  final String? averageLabel;

  NewBarVm({
    required this.dataPoints,
    required this.selectedBarIndex,
    required this.maxYAxisValue,
    this.averageValue,
    this.averageLabel,
  });

  int get numberOfBars => dataPoints.length;
}

class NewMoneyBarGraphDataPointVm {
  final String xLabel;
  final String? xSubLabel;
  final double yValue;
  final String? yLabel;

  NewMoneyBarGraphDataPointVm({
    required this.xLabel,
    this.xSubLabel,
    required this.yValue,
    this.yLabel,
  });
}

/// view model “foreground” overlay text.
class NewForegroundDataVm {
  final String title;

  final String ctaText;

  NewForegroundDataVm({
    required this.title,
    required this.ctaText,
  });
}
