import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class AppOrder {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final String deliveryAddress;
  final DateTime createdAt;

  AppOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
  });

  factory AppOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Parse items list
    final itemsData = data['items'] as List<dynamic>? ?? [];
    final parsedItems = itemsData.map((itemData) {
      // Create a mock document snapshot to reuse CartItem.fromFirestore
      // or we can map it directly since CartItem expects a DocumentSnapshot.
      // Actually, since CartItem.fromFirestore takes a DocumentSnapshot,
      // it's easier to create a fromMap constructor in CartItem or just map it here.
      // For simplicity, let's map it here:
      return CartItem(
        id: itemData['id'] ?? '',
        productId: itemData['productId'] ?? '',
        productName: itemData['productName'] ?? '',
        productPrice: (itemData['productPrice'] ?? 0).toDouble(),
        productImageUrl: itemData['productImageUrl'] ?? '',
        quantity: itemData['quantity'] ?? 1,
        selectedSize: itemData['selectedSize'] ?? '',
        selectedColor: _hexToColor(itemData['selectedColor'] ?? '#000000'),
      );
    }).toList();

    return AppOrder(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: parsedItems,
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      deliveryAddress: data['deliveryAddress'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => {
        'id': item.id,
        'productId': item.productId,
        'productName': item.productName,
        'productPrice': item.productPrice,
        'productImageUrl': item.productImageUrl,
        'quantity': item.quantity,
        'selectedSize': item.selectedSize,
        'selectedColor': _colorToHex(item.selectedColor),
      }).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String _colorToHex(color) {
    final r = (color.r * 255.0).round().clamp(0, 255);
    final g = (color.g * 255.0).round().clamp(0, 255);
    final b = (color.b * 255.0).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
