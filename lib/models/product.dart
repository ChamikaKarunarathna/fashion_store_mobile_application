import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for a product in the CK Mart store.
///
/// Products are stored in the Firestore `products` collection.
/// Colors are stored as hex strings (e.g., "#FF0000") and
/// converted to/from Flutter [Color] objects.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String imageUrl;
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
    required this.imageUrl,
    this.isFavorite = false,
    this.isNew = false,
    this.rating = 4.5,
    this.colors = const [Colors.black, Colors.white],
    this.sizes = const ['XS', 'S', 'M', 'L', 'XL'],
    this.description = 'Crafted from high-grade materials, this item features a minimalist silhouette perfect for any occasion.',
  });

  /// Creates a [Product] from a Firestore document snapshot.
  ///
  /// Handles missing or null fields gracefully with defaults.
  /// Colors are stored as hex strings in Firestore and converted
  /// to Flutter [Color] objects.
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Parse colors from hex strings
    List<Color> colors = [Colors.black, Colors.white];
    if (data['colors'] != null) {
      colors = (data['colors'] as List<dynamic>)
          .map((hex) => _hexToColor(hex as String))
          .toList();
    }

    // Parse sizes
    List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];
    if (data['sizes'] != null) {
      sizes = (data['sizes'] as List<dynamic>)
          .map((s) => s as String)
          .toList();
    }

    return Product(
      id: doc.id,
      name: data['name'] ?? 'Unknown Product',
      category: data['category'] ?? 'Uncategorized',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice'] != null
          ? (data['originalPrice']).toDouble()
          : null,
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      isNew: data['isNew'] ?? false,
      rating: (data['rating'] ?? 4.5).toDouble(),
      colors: colors,
      sizes: sizes,
      description: data['description'] ??
          'Crafted from high-grade materials, this item features a minimalist silhouette perfect for any occasion.',
    );
  }

  /// Converts this product to a Firestore-compatible map.
  ///
  /// Colors are stored as hex strings for Firestore compatibility.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'isNew': isNew,
      'rating': rating,
      'colors': colors.map((c) => _colorToHex(c)).toList(),
      'sizes': sizes,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts a hex color string (e.g., "#FF0000") to a Flutter [Color].
  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add full opacity if not specified
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Converts a Flutter [Color] to a hex string (e.g., "#FF0000").
  static String _colorToHex(Color color) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
