import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0; // 0: Card, 1: Apple Pay, 2: PayPal

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
                      color: AppTheme.primaryGreen.withOpacity(0.3),
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
                  // Delivery Address Header
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
                      Text(
                        'CHANGE',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delivery Address Form
                  Row(
                    children: [
                      Expanded(child: _buildInputField('FIRST NAME', 'Chamika')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInputField('LAST NAME', 'Kalhara')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputField('STREET ADDRESS', '1/123 Dampagoda', icon: Icons.location_on_outlined),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(flex: 2, child: _buildInputField('CITY', 'Baddegama')),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: _buildInputField('ZIP', '80200')),
                    ],
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
                      color: AppTheme.primaryGreen.withOpacity(0.05),
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
                                  '3 products selected',
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
                                  Positioned(
                                    right: 0,
                                    child: _buildStackedImage('assets/images/product_4.png'), // Replace with actual placeholder later if needed
                                  ),
                                  Positioned(
                                    right: 20,
                                    child: _buildStackedImage('assets/images/cart_2.png'),
                                  ),
                                  Positioned(
                                    right: 40,
                                    child: _buildStackedImage('assets/images/cart_1.png'),
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
                        _buildSummaryRow('Subtotal', '\$419.00'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Standard Delivery', 'FREE'),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Estimated Tax', '\$33.52'),
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
                              '\$452.52',
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
                onPressed: () {
                  // Place order logic
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
            color: isActive ? AppTheme.primaryGreen : AppTheme.borderGrey.withOpacity(0.5),
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
            color: AppTheme.borderGrey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderGrey.withOpacity(0.5)),
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
                color: AppTheme.borderGrey.withOpacity(0.3),
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

  Widget _buildStackedImage(String path) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: AppTheme.borderGrey);
          },
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
