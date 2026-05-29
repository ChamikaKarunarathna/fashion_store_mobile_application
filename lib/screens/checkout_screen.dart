import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_order.dart';
import '../models/cart_item.dart';
import '../services/order_service.dart';
import '../services/user_service.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'shipping_address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double deliveryFee;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _orderService = OrderService();
  final _userService = UserService();
  int _selectedPaymentMethod = 0; // 0: Card, 1: Apple Pay, 2: PayPal
  bool _isPlacingOrder = false;

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
          'CHECKOUT',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
              child: Row(
                children: [
                  _buildStep(1, 'SHIPPING', isActive: true),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  _buildStep(2, 'PAYMENT', isActive: false),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppTheme.borderGrey,
                    ),
                  ),
                  _buildStep(3, 'REVIEW', isActive: false),
                ],
              ),
            ),
            
            const Divider(color: AppTheme.borderGrey),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address section with StreamBuilder
                  StreamBuilder<AppUser?>(
                    stream: _userService.userStream(FirebaseAuth.instance.currentUser?.uid ?? ''),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      
                      final names = user?.fullName.split(' ') ?? [''];
                      final firstName = names.isNotEmpty ? names[0] : '';
                      final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
                      final address = user?.address ?? 'Not set';
                      final city = user?.city ?? 'Not set';
                      final zip = user?.zip ?? 'Not set';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_shipping_outlined, color: AppTheme.primaryGreen, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'DELIVERY ADDRESS',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (user != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ShippingAddressScreen(user: user)),
                                    );
                                  }
                                },
                                child: Text(
                                  'CHANGE',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.primaryGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildInputField('FIRST NAME', firstName)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInputField('LAST NAME', lastName)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInputField('STREET ADDRESS', address, icon: Icons.location_on_outlined),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(flex: 2, child: _buildInputField('CITY', city)),
                              const SizedBox(width: 16),
                              Expanded(flex: 1, child: _buildInputField('ZIP', zip)),
                            ],
                          ),
                        ],
                      );
                    }
                  ),
                  const SizedBox(height: 32),

                  // Payment Method Header
                  Row(
                    children: [
                      const Icon(Icons.payment_outlined, color: AppTheme.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'PAYMENT METHOD',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Methods
                  _buildPaymentCard(
                    index: 0,
                    icon: Icons.credit_card,
                    title: 'Credit / Debit Card',
                    subtitle: 'Visa ending in 4242',
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentCard(
                    index: 1,
                    icon: Icons.account_balance_wallet_outlined, // Apple Pay equivalent
                    title: 'Apple Pay',
                    subtitle: 'Secure checkout with FaceID',
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentCard(
                    index: 2,
                    icon: Icons.public, // PayPal equivalent
                    title: 'PayPal',
                    subtitle: 'Redirect to external wallet',
                  ),
                  const SizedBox(height: 16),

                  // Add New Payment Method
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.textDark),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 16, color: AppTheme.textDark),
                        const SizedBox(width: 8),
                        Text(
                          'ADD NEW PAYMENT METHOD',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Order Summary Header
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'ORDER SUMMARY',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Review Items',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.cartItems.length} products selected',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textGrey,
                                      ),
                                ),
                              ],
                            ),
                            // Image Stack
                            SizedBox(
                              width: 80,
                              height: 36,
                              child: Stack(
                                children: [
                                  if (widget.cartItems.length > 2)
                                    Positioned(
                                      right: 0,
                                      child: _buildStackedImage(widget.cartItems[2].productImageUrl),
                                    ),
                                  if (widget.cartItems.length > 1)
                                    Positioned(
                                      right: 20,
                                      child: _buildStackedImage(widget.cartItems[1].productImageUrl),
                                    ),
                                  if (widget.cartItems.isNotEmpty)
                                    Positioned(
                                      right: 40,
                                      child: _buildStackedImage(widget.cartItems[0].productImageUrl),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: AppTheme.borderGrey),
                        ),
                        _buildSummaryRow('Subtotal', 'Rs. ${widget.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Standard Delivery', 'Rs. ${widget.deliveryFee.toStringAsFixed(2)}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL AMOUNT',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Rs. ${widget.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryGreen,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Secure Payment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security, size: 16, color: AppTheme.textLightGrey),
                      const SizedBox(width: 8),
                      Text(
                        'SSL SECURE PAYMENT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textLightGrey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.borderGrey)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Items will be delivered in 3-5 business days',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isPlacingOrder
                    ? null
                    : () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        setState(() => _isPlacingOrder = true);

                        try {
                          final userDoc = await _userService.userStream(user.uid).first;
                          final addressStr = userDoc?.address != null 
                              ? '${userDoc?.address}, ${userDoc?.city} ${userDoc?.zip}'
                              : 'Address not set';

                          final order = AppOrder(
                            id: '',
                            userId: user.uid,
                            items: widget.cartItems,
                            subtotal: widget.subtotal,
                            deliveryFee: widget.deliveryFee,
                            total: widget.total,
                            status: 'Order Placed',
                            deliveryAddress: addressStr,
                            createdAt: DateTime.now(),
                          );

                          await _orderService.placeOrder(user.uid, order);

                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Order placed successfully!'),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );

                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Failed to place order.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isPlacingOrder = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Place Order',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
      ),
    );
  }

  Widget _buildStep(int step, String label, {required bool isActive}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryGreen : AppTheme.borderGrey.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.textGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.primaryGreen : AppTheme.textLightGrey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppTheme.textGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.borderGrey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderGrey.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: AppTheme.textGrey),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.borderGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.textDark, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedImage(String url) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: AppTheme.borderGrey),
          errorWidget: (context, url, error) => Container(color: AppTheme.borderGrey),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textGrey,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textDark,
              ),
        ),
      ],
    );
  }
}
