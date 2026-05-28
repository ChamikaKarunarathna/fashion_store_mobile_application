import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

/// Service for managing the user's shopping cart in Firestore.
///
/// Cart items are stored as a subcollection under each user's document:
/// `users/{userId}/cart/{cartItemId}`
class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a reference to a user's cart collection.
  CollectionReference _cartCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  /// Returns a real-time stream of the user's cart items.
  ///
  /// Cart items are ordered by the time they were added.
  Stream<List<CartItem>> cartStream(String userId) {
    return _cartCollection(userId)
        .orderBy('addedAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList());
  }

  /// Adds a product to the user's cart.
  ///
  /// If a cart item with the same productId, size, and color already exists,
  /// its quantity is incremented instead of creating a duplicate.
  Future<void> addToCart(String userId, CartItem item) async {
    // Check for existing item with same product, size, and color
    final existing = await _cartCollection(userId)
        .where('productId', isEqualTo: item.productId)
        .where('selectedSize', isEqualTo: item.selectedSize)
        .where('selectedColor', isEqualTo: item.toMap()['selectedColor']) // use string hex
        .get();

    if (existing.docs.isNotEmpty) {
      // Increment quantity of existing item
      final doc = existing.docs.first;
      final currentQty = doc['quantity'] as int;
      await doc.reference.update({'quantity': currentQty + item.quantity});
    } else {
      // Add new cart item
      await _cartCollection(userId).add(item.toMap());
    }
  }

  /// Removes a cart item by its document ID.
  Future<void> removeFromCart(String userId, String cartItemId) async {
    await _cartCollection(userId).doc(cartItemId).delete();
  }

  /// Updates the quantity of a cart item.
  ///
  /// If [quantity] is less than 1, the item is removed instead.
  Future<void> updateQuantity(
    String userId,
    String cartItemId,
    int quantity,
  ) async {
    if (quantity < 1) {
      await removeFromCart(userId, cartItemId);
    } else {
      await _cartCollection(userId).doc(cartItemId).update({
        'quantity': quantity,
      });
    }
  }

  /// Removes all items from the user's cart.
  Future<void> clearCart(String userId) async {
    final snapshot = await _cartCollection(userId).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Returns the total number of items in the user's cart.
  Future<int> getCartCount(String userId) async {
    final snapshot = await _cartCollection(userId).get();
    return snapshot.docs.fold<int>(
      0,
      (total, doc) => total + (doc['quantity'] as int),
    );
  }
}
