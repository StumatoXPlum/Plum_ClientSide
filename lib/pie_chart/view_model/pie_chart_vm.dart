import 'package:task1/pie_chart/model/pie_model.dart';

class HomeVisualSectionItemVm {
  final String category;
  final String amount;
  final double percentage;

  HomeVisualSectionItemVm({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  /// Converts PieModel (API Response) to HomeVisualSectionItemVm List
  static List<HomeVisualSectionItemVm> getPieChartData(PieModel pieModel) {
    return pieModel.pieData.sections
        .map((section) => HomeVisualSectionItemVm(
              category: section.category,
              amount: section.amount,
              percentage: section.percentage,
            ))
        .toList();
  }
}

class ForegroundWidgetVm {
  final String header;
  final String amount;
  final String buttonText;

  ForegroundWidgetVm({
    required this.header,
    required this.amount,
    required this.buttonText,
  });
}

class DummyPieData {
  static PieModel getDummyPieData() => PieModel(
        title: 'AMOUNT SPENT ON TRANSPORTATION',
        amount: '₹11,250.00',
        cta: Cta(label: 'VIEW CASH FLOW', action: 'deeplink'),
        pieData: PieData(
          sections: [
            Section(category: 'Fuel', amount: '₹4,500', percentage: 40.0),
            Section(
                category: 'Public Transport',
                amount: '₹3,250',
                percentage: 29.0),
            Section(category: 'Taxi', amount: '₹2,500', percentage: 23.0),
            Section(category: 'Others', amount: '₹1,000', percentage: 8.0),
          ],
        ),
      );
}
