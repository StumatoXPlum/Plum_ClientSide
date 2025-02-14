import 'package:task1/streaks_info/model/streaks_model.dart';

class StreaksVm {
  final String title;
  final String ctaText;
  final List<StreaksCard> cardData;

  StreaksVm({
    required this.title,
    required this.ctaText,
    required this.cardData,
  });
  factory StreaksVm.fromModel(StreaksModel model) {
    return StreaksVm(
      title: model.title,
      ctaText: model.ctaText,
      cardData: model.cardData,
    );
  }
}

class DummyStreaksData {
  StreaksModel getStreaksData() {
    return StreaksModel(
      title: "2 subscriptions have \nbeen active for 8 months.",
      ctaText: "VIEW DETAILS",
      cardData: [
        StreaksCard(
          title: "Cook",
          iconUrl:
              "https://res.cloudinary.com/dn1rz6ufr/image/upload/v1739522770/streak_l7zekq.svg",
          subtitle: "2x Streak",
          amount: "6700",
          logo: "logo_url",
        ),
        StreaksCard(
          title: "Fuel",
          iconUrl:
              "https://res.cloudinary.com/dn1rz6ufr/image/upload/v1739522770/streak_l7zekq.svg",
          subtitle: "3x Streak",
          amount: "2000",
          logo: "logo_url",
        ),
        StreaksCard(
          title: "Rent",
          iconUrl:
              "https://res.cloudinary.com/dn1rz6ufr/image/upload/v1739522770/streak_l7zekq.svg",
          subtitle: "5x Streak",
          amount: "8000",
          logo: "logo_url",
        ),
      ],
    );
  }
}
