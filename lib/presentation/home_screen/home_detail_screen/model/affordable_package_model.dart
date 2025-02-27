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
    imageUrl: 'assets/package/p6.png',
    title: 'Bachelor',
    price: 'AED 1299',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/package/p5.png',
    title: 'Family',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/package/p4.png',
    title: 'Classic',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/package/p2.png',
    title: 'Executive',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/package/p1.png',
    title: 'Friends',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
  AffordablePackageModel(
    imageUrl: 'assets/package/p3.png',
    title: 'Premium',
    price: 'AED 2499',
    description: 'Spicy with black pepper sauce',
  ),
];
