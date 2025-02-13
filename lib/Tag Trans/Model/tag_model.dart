class TagModel {
  final String title;
  final String assetUrl;
  final String ctaText;

  TagModel({
    required this.title,
    required this.assetUrl,
    required this.ctaText,
  });

  static final TagModel dummyData = TagModel(
    title: "tag transactions \nfor better insights",
    ctaText: "TAG TRANSACTIONS",
    assetUrl: "https://res.cloudinary.com/dn1rz6ufr/image/upload/v1739433044/tag_design_q37m26.svg",
  );
}
