import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

/// Dummy data for cart items only.
///
/// Products and categories are now fetched from Firestore.
/// This file will be removed in Stage 4 when cart is
/// also persisted in Firestore.
class DummyData {
  static final List<CartItem> cartItems = [
    CartItem(
      product: Product(
        id: 'cart1',
        name: 'Linen Utility Overshirt',
        category: 'MEN',
        price: 89.00,
        imageUrl: 'assets/images/cart_1.png',
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
        imageUrl: 'assets/images/cart_2.png',
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
        imageUrl: 'assets/images/cart_3.png',
      ),
      quantity: 1,
      selectedSize: '42',
      selectedColor: const Color(0xFFF0F0F0),
    ),
  ];
}
