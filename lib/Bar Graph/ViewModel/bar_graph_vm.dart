class MoneyBarGraphVm {
  final List<MoneyBarGraphDataPointVm> dataPoints;
  final int selectedBarIndex;
  final double maxYAxisValue;
  final double? averageValue;
  final String? averageLabel;

  MoneyBarGraphVm({
    required this.dataPoints,
    required this.selectedBarIndex,
    required this.maxYAxisValue,
    this.averageValue,
    this.averageLabel,
  });

  int get numberOfBars => dataPoints.length;
}


class MoneyBarGraphDataPointVm {
  final String xLabel;
  final String? xSubLabel;
  final double yValue;
  final String? yLabel;

  MoneyBarGraphDataPointVm({
    required this.xLabel,
    this.xSubLabel,
    required this.yValue,
    this.yLabel,
  });
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
