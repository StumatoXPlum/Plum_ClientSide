import 'package:task1/presentation/viewmodels/bar_graph_vm.dart';

class DummyBarData {
  static MoneyBarGraphVm getMockData() {
    return MoneyBarGraphVm(
      dataPoints: [
        MoneyBarGraphDataPointVm(xLabel: "APR", yValue: 500, yLabel: "\$500"),
        MoneyBarGraphDataPointVm(xLabel: "MAY", yValue: 700, yLabel: "\$700"),
        MoneyBarGraphDataPointVm(xLabel: "JUN", yValue: 700, yLabel: "\$300"),
        MoneyBarGraphDataPointVm(xLabel: "JUL", yValue: 900, yLabel: "\$900"),
        MoneyBarGraphDataPointVm(xLabel: "AUG", yValue: 900, yLabel: "\$900"),
      ],
      selectedBarIndex: 1,
      maxYAxisValue: 800,
      averageValue: 600,
      averageLabel: "Avg: ₹600",
    );
  }
}
