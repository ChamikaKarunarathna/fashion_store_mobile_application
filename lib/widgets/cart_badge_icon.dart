import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

/// A shopping cart icon that displays a dynamic badge with the
/// current number of items in the user's cart.
class CartBadgeIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const CartBadgeIcon({
    super.key,
    this.icon = Icons.shopping_cart_outlined,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cartService = CartService();

    if (user == null) {
      return Icon(icon, size: size, color: color);
    }

    return StreamBuilder<List<CartItem>>(
      stream: cartService.cartStream(user.uid),
      builder: (context, snapshot) {
        int count = 0;
        if (snapshot.hasData) {
          count = snapshot.data!.fold(0, (sum, item) => sum + item.quantity);
        }

        if (count == 0) {
          return Icon(icon, size: size, color: color);
        }

        return Badge(
          label: Text('$count'),
          backgroundColor: Colors.red,
          child: Icon(icon, size: size, color: color),
        );
      },
    );
  }
}
