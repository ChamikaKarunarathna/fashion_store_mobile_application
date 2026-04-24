import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../theme/app_theme.dart';
import '../utils/dummy_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _bottomNavIndex = 2; // Default to Cart
  List<CartItem> _items = [];

  @override
  void initState() {
    super.initState();
    // Copy dummy data for local state mutation
    _items = List.from(DummyData.cartItems);
  }

  double get _subtotal {
    return _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  final double _deliveryFee = 15.00;

  double get _total => _subtotal + _deliveryFee;

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      _items.clear();
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark, size: 20),
        ),
        title: Text(
          'YOUR CART',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.shopping_bag_outlined, color: AppTheme.textDark, size: 24),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ITEMS (${_items.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                ),
                GestureDetector(
                  onTap: _clearAll,
                  child: Text(
                    'Clear All',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                ),
              ],
            ),
          ),
          
          // Item List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.borderGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.product.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_outlined, color: AppTheme.textLightGrey);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.product.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeItem(index),
                                child: const Icon(Icons.delete_outline, color: AppTheme.textGrey, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.borderGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Size: ${item.selectedSize}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: item.selectedColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.borderGrey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${item.product.price.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                              ),
                              // Quantity Control
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.borderGrey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _decrementQuantity(index),
                                      child: const Icon(Icons.remove, size: 16, color: AppTheme.textDark),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => _incrementQuantity(index),
                                      child: const Icon(Icons.add, size: 16, color: AppTheme.primaryGreen),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Summary Footer
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.borderGrey)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
                    Text('\$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery', style: Theme.of(context).textTheme.bodyMedium),
                    Text('\$${_deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: AppTheme.borderGrey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                    ),
                    Text(
                      '\$${_total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                            fontSize: 24,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Checkout
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PROCEED TO CHECKOUT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
          // Usually here you'd handle top-level navigation.
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.textGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: const Text('9'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              label: const Text('9'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
