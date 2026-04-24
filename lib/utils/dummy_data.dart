import '../models/product.dart';

class DummyData {
  static final List<String> categories = ['All', 'Men', 'Women', 'Accessories', 'Footwear'];

  static final List<Product> trendingProducts = [
    Product(
      id: '1',
      name: 'Classic Linen Shirt',
      category: 'MEN',
      price: 89.00,
      imagePath: 'assets/images/product_1.png',
      isFavorite: true,
    ),
    Product(
      id: '2',
      name: 'Minimalist Tote Bag',
      category: 'ACCESSORIES',
      price: 120.00,
      imagePath: 'assets/images/product_2.png',
    ),
    Product(
      id: '3',
      name: 'Silk Summer Dress',
      category: 'WOMEN',
      price: 145.00,
      imagePath: 'assets/images/product_3.png',
    ),
    Product(
      id: '4',
      name: 'Urban Leather Boots',
      category: 'FOOTWEAR',
      price: 210.00,
      imagePath: 'assets/images/product_4.png',
    ),
  ];
}
