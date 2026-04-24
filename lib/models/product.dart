import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String imagePath;
  final bool isFavorite;
  final bool isNew;
  final double rating;
  final List<Color> colors;
  final List<String> sizes;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.imagePath,
    this.isFavorite = false,
    this.isNew = false,
    this.rating = 4.5,
    this.colors = const [Colors.black, Colors.white],
    this.sizes = const ['XS', 'S', 'M', 'L', 'XL'],
    this.description = 'Crafted from high-grade materials, this item features a minimalist silhouette perfect for any occasion.',
  });
}
