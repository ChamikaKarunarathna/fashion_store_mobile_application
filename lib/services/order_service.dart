import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_order.dart';
import 'cart_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CartService _cartService = CartService();

  CollectionReference _ordersCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('orders');
  }

  Stream<List<AppOrder>> ordersStream(String userId) {
    return _ordersCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AppOrder.fromFirestore(doc)).toList());
  }

  Future<void> placeOrder(String userId, AppOrder order) async {
    // Save the order to Firestore
    await _ordersCollection(userId).add(order.toMap());

    // Clear the cart after placing the order
    await _cartService.clearCart(userId);
  }
}
