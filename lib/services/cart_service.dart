import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing the user's shopping cart in Firestore.
///
/// Cart items are stored as a subcollection under each user's document:
/// `users/{userId}/cart/{cartItemId}`
///
/// Each cart item stores a product ID reference, quantity,
/// selected size, and selected color.
class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns a reference to a user's cart collection.
  CollectionReference _cartCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  /// Returns a real-time stream of the user's cart items.
  ///
  /// Cart items are ordered by the time they were added.
  Stream<QuerySnapshot> cartStream(String userId) {
    return _cartCollection(userId)
        .orderBy('addedAt', descending: false)
        .snapshots();
  }

  /// Adds a product to the user's cart.
  ///
  /// If a cart item with the same productId, size, and color already exists,
  /// its quantity is incremented instead of creating a duplicate.
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    required String selectedSize,
    required String selectedColor,
  }) async {
    // Check for existing item with same product, size, and color
    final existing = await _cartCollection(userId)
        .where('productId', isEqualTo: productId)
        .where('selectedSize', isEqualTo: selectedSize)
        .where('selectedColor', isEqualTo: selectedColor)
        .get();

    if (existing.docs.isNotEmpty) {
      // Increment quantity of existing item
      final doc = existing.docs.first;
      final currentQty = doc['quantity'] as int;
      await doc.reference.update({'quantity': currentQty + quantity});
    } else {
      // Add new cart item
      await _cartCollection(userId).add({
        'productId': productId,
        'quantity': quantity,
        'selectedSize': selectedSize,
        'selectedColor': selectedColor,
        'addedAt': FieldValue.serverTimestamp(),
      });
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
