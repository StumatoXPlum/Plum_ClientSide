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
    imageUrl: 'assets/drinks/d1.png',
    title: 'Strawberry Juice',
    price: 'AED 1299',
    description: 'A refreshing burst of sweet and tangy strawberries.',
  ),
  DrinkModel(
    imageUrl: 'assets/drinks/d2.png',
    title: 'Blue Lemonade',
    price: 'AED 2499',
    description: 'A zesty lemonade twist with a vibrant blue hue.',
  ),
  DrinkModel(
    imageUrl: 'assets/drinks/d3.png',
    title: 'Fresh Mint',
    price: 'AED 2499',
    description: 'Cool, crisp, and invigorating minty freshness.',
  ),
  DrinkModel(
    imageUrl: 'assets/drinks/d4.png',
    title: 'Iced Tea',
    price: 'AED 2499',
    description: 'A smooth, chilled tea perfect for any time of day.',
  ),
];
