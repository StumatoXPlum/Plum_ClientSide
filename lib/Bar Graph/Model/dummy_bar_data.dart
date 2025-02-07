import 'package:task1/Bar%20Graph/ViewModel/bar_graph_vm.dart';

class DummyBarData {
  static MoneyBarGraphVm getMockGraphData() {
    return MoneyBarGraphVm(
      dataPoints: [
        MoneyBarGraphDataPointVm(xLabel: "APR", yValue: 500, yLabel: "\$500"),
        MoneyBarGraphDataPointVm(xLabel: "MAY", yValue: 700, yLabel: "\$700"),
        MoneyBarGraphDataPointVm(xLabel: "JUN", yValue: 300, yLabel: "\$300"),
        MoneyBarGraphDataPointVm(xLabel: "JUL", yValue: 900, yLabel: "\$900"),
        MoneyBarGraphDataPointVm(xLabel: "AUG", yValue: 900, yLabel: "\$900"),
      ],
      selectedBarIndex: 1,
      maxYAxisValue: 800,
      averageValue: 600,
      averageLabel: "Avg: ₹600",
    );
  }

  static ForegroundDataVm getMockForegroundData() {
    return ForegroundDataVm(
      header: 'INVESTMENTS ARE HIGHER\nTHAN LAST MONTH',
      amount: '₹1,00,250',
      amountSub: '.00',
      actionText: 'VIEW CASH FLOW',
    );
  }
}
