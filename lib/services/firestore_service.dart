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

  /// TEMPORARY: Uploads sample data to Firestore
  Future<void> uploadSampleData() async {
    try {
      final categories = [
        {'id': 'cat1', 'name': 'All', 'imageUrl': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=500&auto=format&fit=crop&q=60', 'order': 0},
        {'id': 'cat2', 'name': 'Dresses', 'imageUrl': 'https://images.unsplash.com/photo-1515347619362-75fe218ee5eb?w=500&auto=format&fit=crop&q=60', 'order': 1},
        {'id': 'cat3', 'name': 'Tops', 'imageUrl': 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=500&auto=format&fit=crop&q=60', 'order': 2},
        {'id': 'cat4', 'name': 'Pants', 'imageUrl': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500&auto=format&fit=crop&q=60', 'order': 3},
        {'id': 'cat5', 'name': 'Accessories', 'imageUrl': 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=500&auto=format&fit=crop&q=60', 'order': 4},
      ];

      for (var cat in categories) {
        await _firestore.collection('categories').doc(cat['id'] as String).set(cat);
      }

      final products = [
        {
          'name': 'Summer Floral Dress',
          'description': 'A beautiful floral dress perfect for summer days.',
          'price': 13800.00,
          'category': 'Dresses',
          'imageUrl': 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500&auto=format&fit=crop&q=60',
          'sizes': ['S', 'M', 'L'],
          'colors': ['#FFB6C1', '#FFFFFF'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Casual White Tee',
          'description': 'Essential cotton blend white t-shirt.',
          'price': 6000.00,
          'category': 'Tops',
          'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&auto=format&fit=crop&q=60',
          'sizes': ['S', 'M', 'L', 'XL'],
          'colors': ['#FFFFFF', '#000000', '#808080'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'High-Waisted Jeans',
          'description': 'Classic blue high-waisted denim jeans.',
          'price': 16500.00,
          'category': 'Pants',
          'imageUrl': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500&auto=format&fit=crop&q=60',
          'sizes': ['28', '30', '32', '34'],
          'colors': ['#0000FF', '#000000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Leather Handbag',
          'description': 'Premium crafted leather handbag.',
          'price': 36000.00,
          'category': 'Accessories',
          'imageUrl': 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=500&auto=format&fit=crop&q=60',
          'sizes': ['Standard'],
          'colors': ['#8B4513', '#000000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Elegant Evening Gown',
          'description': 'Stunning black gown for special occasions.',
          'price': 57000.00,
          'category': 'Dresses',
          'imageUrl': 'https://images.unsplash.com/photo-1566160980590-449e2ab17697?w=500&auto=format&fit=crop&q=60',
          'sizes': ['XS', 'S', 'M'],
          'colors': ['#000000', '#FF0000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Striped Crop Top',
          'description': 'Cute striped crop top for casual wear.',
          'price': 7350.00,
          'category': 'Tops',
          'imageUrl': 'https://images.unsplash.com/photo-1503342394128-c104d54dba01?w=500&auto=format&fit=crop&q=60',
          'sizes': ['S', 'M', 'L'],
          'colors': ['#FFFFFF', '#0000FF'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Wide Leg Trousers',
          'description': 'Comfortable and stylish wide-leg pants.',
          'price': 14400.00,
          'category': 'Pants',
          'imageUrl': 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=500&auto=format&fit=crop&q=60',
          'sizes': ['S', 'M', 'L'],
          'colors': ['#F5F5DC', '#000000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Silk Scarf',
          'description': 'Beautiful patterned silk scarf.',
          'price': 10500.00,
          'category': 'Accessories',
          'imageUrl': 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=500&auto=format&fit=crop&q=60',
          'sizes': ['Standard'],
          'colors': ['#FF0000', '#0000FF', '#008000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Knitted Sweater',
          'description': 'Warm and cozy oversized sweater.',
          'price': 19500.00,
          'category': 'Tops',
          'imageUrl': 'https://images.unsplash.com/photo-1434389678232-0545f7712330?w=500&auto=format&fit=crop&q=60',
          'sizes': ['M', 'L', 'XL'],
          'colors': ['#808080', '#FFFFFF', '#A52A2A'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Denim Jacket',
          'description': 'Classic style denim jacket.',
          'price': 25500.00,
          'category': 'Tops',
          'imageUrl': 'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=500&auto=format&fit=crop&q=60',
          'sizes': ['S', 'M', 'L'],
          'colors': ['#0000FF', '#000000'],
          'isFavorite': false,
          'createdAt': FieldValue.serverTimestamp(),
        }
      ];

      for (var product in products) {
        await _firestore.collection('products').add(product);
      }
      print('Sample data uploaded successfully!');
    } catch (e) {
      print('Error uploading sample data: $e');
      rethrow;
    }
  }
}
