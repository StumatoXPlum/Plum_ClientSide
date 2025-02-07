class HomeVisualSectionItemVm {
  final double percentage;
  HomeVisualSectionItemVm({required this.percentage});
  static List<HomeVisualSectionItemVm> getPieChartData() {
    return [
      HomeVisualSectionItemVm(percentage: 50.0),
      HomeVisualSectionItemVm(percentage: 30.0),
      HomeVisualSectionItemVm(percentage: 20.0),
      HomeVisualSectionItemVm(percentage: 70.0),
    ];
  }
}

class ForegroundWidgetVm {
  final String header;
  final String amount;
  final String amountSub;
  final String buttonText;

  ForegroundWidgetVm({
    required this.header,
    required this.amount,
    required this.amountSub,
    required this.buttonText,
  });
}

// class InAndOutPieGraph extends StatelessWidget {
//   final List<HomeVisualSectionItemVm> items;
//   final int colorNumber;
//   final void Function(int)? onPieSectionTap;

//   const InAndOutPieGraph({
//     super.key,
//     required this.items,
//     required this.colorNumber,
//     this.onPieSectionTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final pieSize = screenWidth * 0.5;

//     final List<Color> sectionColors = [
//       Color(0xff818180),
//       Color(0xffDDDCDC),
//       Color(0xff888989),
//       Color(0xff2F2E2E),
//     ];

//     return SizedBox(
//       height: pieSize,
//       width: pieSize,
//       child: PieChart(
//         PieChartData(
//           sections: items.asMap().entries.map((entry) {
//             final index = entry.key;
//             final item = entry.value;

//             return PieChartSectionData(
//               value: item.percentage,
//               color: sectionColors[index % sectionColors.length],
//               showTitle: false,
//             );
//           }).toList(),
//           sectionsSpace: 0,
//           startDegreeOffset: 270,
//           pieTouchData: PieTouchData(
//             touchCallback: (touchEvent, pieTouchResponse) {
//               if (touchEvent is FlTapUpEvent) {
//                 final index =
//                     pieTouchResponse?.touchedSection?.touchedSectionIndex;
//                 if (index != null && index >= 0) {
//                   onPieSectionTap?.call(index);
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomeVisualSectionItemVm {
//   final double? percentage;
//   HomeVisualSectionItemVm({required this.percentage});
// }
