class RecurringVm {
  final String count;
  final String type;
  final String amount;
  final String date;

  const RecurringVm({
    required this.count,
    required this.type,
    required this.amount,
    required this.date,
  });
}

class DummyRecurringData {
  static List<RecurringVm> getDummyRecurringData() => [
        RecurringVm(
          count: '2',
          type: 'Cook',
          amount: '₹6,700',
          date: '02 AUG',
        ),
        RecurringVm(
          count: '3',
          type: 'Fuel',
          amount: '₹2,700',
          date: '15 SEP',
        ),
        RecurringVm(
          count: '1',
          type: 'Wifi',
          amount: '₹3,000',
          date: '10 OCT',
        ),
      ];
}
