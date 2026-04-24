class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String imagePath;
  final bool isFavorite;
  final bool isNew;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imagePath,
    this.isFavorite = false,
    this.isNew = false,
  });
}
