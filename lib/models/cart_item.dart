import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model for an item in the shopping cart.
///
/// We denormalize basic product info (name, price, imageUrl) into
/// the cart document to avoid N+1 queries when displaying the cart.
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImageUrl;
  final int quantity;
  final String selectedSize;
  final Color selectedColor;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  /// Creates a [CartItem] from a Firestore document snapshot.
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? 'Unknown',
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      productImageUrl: data['productImageUrl'] ?? '',
      quantity: data['quantity'] ?? 1,
      selectedSize: data['selectedSize'] ?? '',
      selectedColor: _hexToColor(data['selectedColor'] ?? '#000000'),
    );
  }

  /// Converts this cart item to a Firestore-compatible map.
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': _colorToHex(selectedColor),
      'addedAt': FieldValue.serverTimestamp(),
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
