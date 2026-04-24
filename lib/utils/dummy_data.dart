import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

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

  static final List<Product> collectionProducts = [
    Product(
      id: 'c1',
      name: 'Minimalist Silk Slip',
      category: 'CK ESSENTIALS',
      price: 75.00,
      originalPrice: 99.00,
      imagePath: 'assets/images/collection_1.png',
    ),
    Product(
      id: 'c2',
      name: 'Oversized Wool Blaze',
      category: 'CK ESSENTIALS',
      price: 145.00,
      originalPrice: 199.00, // Adjusted from screenshot to make sense, but keeps strikethrough logic.
      imagePath: 'assets/images/collection_2.png',
      isFavorite: true,
    ),
    Product(
      id: 'c3',
      name: 'High-Waist Trousers',
      category: 'CK ESSENTIALS',
      price: 89.00,
      originalPrice: 99.00,
      imagePath: 'assets/images/collection_3.png',
      isNew: true,
    ),
    Product(
      id: 'c4',
      name: 'Cropped Linen Shirt',
      category: 'CK ESSENTIALS',
      price: 55.00,
      originalPrice: 99.00,
      imagePath: 'assets/images/collection_4.png',
    ),
    Product(
      id: 'c5',
      name: 'Satin Midi Skirt',
      category: 'CK ESSENTIALS',
      price: 68.00,
      originalPrice: 99.00,
      imagePath: 'assets/images/collection_5.png',
    ),
    Product(
      id: 'c6',
      name: 'Ribbed Knit Sweater',
      category: 'CK ESSENTIALS',
      price: 92.00,
      originalPrice: 99.00,
      imagePath: 'assets/images/collection_6.png',
      isNew: true,
    ),
  ];

  static final List<CartItem> cartItems = [
    CartItem(
      product: Product(
        id: 'cart1',
        name: 'Linen Utility Overshirt',
        category: 'MEN',
        price: 89.00,
        imagePath: 'assets/images/cart_1.png',
      ),
      quantity: 1,
      selectedSize: 'L',
      selectedColor: const Color(0xFF4A4A4A),
    ),
    CartItem(
      product: Product(
        id: 'cart2',
        name: 'High-Waist Tailored Trouser',
        category: 'WOMEN',
        price: 124.50,
        imagePath: 'assets/images/cart_2.png',
      ),
      quantity: 1,
      selectedSize: 'M',
      selectedColor: const Color(0xFFE5D5C5),
    ),
    CartItem(
      product: Product(
        id: 'cart3',
        name: 'Essential Leather Sneakers',
        category: 'FOOTWEAR',
        price: 155.00,
        imagePath: 'assets/images/cart_3.png',
      ),
      quantity: 1,
      selectedSize: '42',
      selectedColor: const Color(0xFFF0F0F0),
    ),
  ];
}
