class StreaksVm {
  final String title;
  final String type;
  final String amount;
  final String streakCount;
  final String investmentCount;
  final String monthCount;
  final String ctaText;

  const StreaksVm({
    required this.title,
    required this.type,
    required this.amount,
    required this.streakCount,
    required this.investmentCount,
    required this.monthCount,
    required this.ctaText,
  });
}

class DummyStreaksData {
  static List<StreaksVm> getDummyStreaksData() => [
        StreaksVm(
            title: 'subscriptions have \nbeen active for month.',
            type: 'Cook',
            amount: '₹6,700',
            streakCount: '3',
            investmentCount: '2',
            monthCount: '8',
            ctaText: 'VIEW RECURRING PAYMENTS'),
        StreaksVm(
            title: 'investments have an \nmonth streak',
            type: 'Shopping',
            amount: '₹1,700',
            streakCount: '2',
            investmentCount: '2',
            monthCount: '1',
            ctaText: 'Check Now'),
        StreaksVm(
            title: 'investments have an \nmonth streak',
            type: 'Rent',
            amount: '₹5,700',
            streakCount: '3',
            investmentCount: '2',
            monthCount: '4',
            ctaText: 'Check Now'),
      ];
}
