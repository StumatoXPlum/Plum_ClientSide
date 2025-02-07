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
  static StreaksVm getDummyStreaksData() => StreaksVm(
        type: 'Cook',
        amount: '₹6,700',
        streakCount: '3',
        investmentCount: '2',
        monthCount: '8',
      );
}
