class DrinkModel {
  final String imageUrl;
  final String title;
  final String price;
  final String description;

  DrinkModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
  });
}

List<DrinkModel> drinks = [
  DrinkModel(
    imageUrl: 'assets/home_assets/drink.png',
    title: 'JD Cinamon',
    price: 'AED 1299',
    description: 'Cool and refreshing, perfect for summer days.',
  ),
  DrinkModel(
    imageUrl: 'assets/home_assets/drink.png',
    title: 'Champagne',
    price: 'AED 2499',
    description: 'Cool and refreshing, perfect for summer days.',
  ),
];
