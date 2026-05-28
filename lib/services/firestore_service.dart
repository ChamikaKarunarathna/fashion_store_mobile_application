import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

/// Service for fetching product and category data from Firestore.
///
/// Products are pre-loaded into Firestore by an admin and are
/// read-only from the app's perspective (enforced by security rules).
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches all products from the `products` collection.
  ///
  /// Products are ordered by creation date (newest first).
  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  /// Fetches products filtered by [category].
  ///
  /// If [category] is 'All', returns all products.
  Future<List<Product>> getProductsByCategory(String category) async {
    if (category == 'All') {
      return getProducts();
    }

    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  /// Fetches the list of category names from the `categories` collection.
  ///
  /// Categories are ordered by their `order` field.
  Future<List<String>> getCategories() async {
    final snapshot = await _firestore
        .collection('categories')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  /// Returns a real-time stream of all products.
  ///
  /// Useful for listening to changes if products are updated in Firestore.
  Stream<List<Product>> productsStream() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }
}
