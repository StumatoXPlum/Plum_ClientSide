class StreaksVm {
  final String type;
  final String amount;
  final String streakCount;
  final String investmentCount;
  final String monthCount;

  const StreaksVm({
    required this.type,
    required this.amount,
    required this.streakCount,
    required this.investmentCount,
    required this.monthCount,
  });
}

class DummyStreaksData {
  static List<StreaksVm> getDummyStreaksData() => [
    StreaksVm(
        type: 'Cook',
        amount: '₹6,700',
        streakCount: '3',
        investmentCount: '2',
        monthCount: '8',
      ),
    StreaksVm(
        type: 'Shopping',
        amount: '₹1,700',
        streakCount: '2',
        investmentCount: '2',
        monthCount: '8',
      ),
    StreaksVm(
        type: 'Rent',
        amount: '₹5,700',
        streakCount: '3',
        investmentCount: '2',
        monthCount: '8',
      ),
  ];
}
