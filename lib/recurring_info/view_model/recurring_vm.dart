
import 'package:task1/recurring_info/model/recurring_model.dart';

class RecurringVm {
  final String title;
  final String ctaText;
  final List<RecurringCard> cardData;

  RecurringVm({
    required this.title,
    required this.ctaText,
    required this.cardData,
  });
  factory RecurringVm.fromModel(RecurringModel model) {
    return RecurringVm(
      title: model.title,
      ctaText: model.ctaText,
      cardData: model.cardData,
    );
  }
}


// dummy data
class DummyRecurringData {
  RecurringModel getRecurringData() {
    return RecurringModel(
      title: "2 recurring \npayments detected",
      ctaText: "ADD NOW",
      cardData: [
        RecurringCard(
          title: "Cook",
          subtitle: "PAID 10 OCT",
          amount: "6700",
          logo: "logo_url",
        ),
        RecurringCard(
          title: "Fuel",
          subtitle: "PAID 12 AUG",
          amount: "2000",
          logo: "logo_url",
        ),
        RecurringCard(
          title: "Rent",
          subtitle: "PAID 20 MAY",
          amount: "8000",
          logo: "logo_url",
        ),
      ],
    );
  }
}
