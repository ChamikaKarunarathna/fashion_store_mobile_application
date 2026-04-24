class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imagePath;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });
}
