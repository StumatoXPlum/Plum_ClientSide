class BankVm {
  final String title;
  final String type;
  final String amount;
  final String interestAmount;
  final String bankName;
  final String lastDigits;
  final String ctaText;

  const BankVm({
    required this.title,
    required this.type,
    required this.amount,
    required this.interestAmount,
    required this.bankName,
    required this.lastDigits,
    required this.ctaText,
  });
}

class DummyinterestData {
  static List<BankVm> getDummyInterestData() => [
        BankVm(
          title: 'INTEREST EARNED \nHAS CROSSED',
          type: 'Interest',
          amount: '450.00',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
        BankVm(
          title: 'investments have an \nmonth streak',
          type: 'Shopping',
          amount: '1,700',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
        BankVm(
          title: 'investments have an \nmonth streak',
          type: 'Rent',
          amount: '5,700',
          interestAmount: '1700',
          bankName: 'Axis Bank',
          lastDigits: '6782',
          ctaText: 'VIEW BALANCE',
        ),
      ];
}
