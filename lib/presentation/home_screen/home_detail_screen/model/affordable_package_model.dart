class AffordablePackageModel {
  final String imageUrl;
  final String title;
  final String price;
  final String description;

  AffordablePackageModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
  });
}

List<AffordablePackageModel> affordablePackages = [
  AffordablePackageModel(
    imageUrl: 'assets/home_assets/package.png',
    title: 'Bachelor',
    price: 'AED 1299',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/home_assets/package.png',
    title: 'Family',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
];
