import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _cartService = CartService();
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 2; // Default to 'M' for demo
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    // Determine if we have a discount to show
    String discountText = '';
    if (widget.product.originalPrice != null && widget.product.originalPrice! > widget.product.price) {
      double discount = ((widget.product.originalPrice! - widget.product.price) / widget.product.originalPrice!) * 100;
      discountText = '${discount.toStringAsFixed(0)}% OFF';
    }

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
          'PRODUCT DETAILS',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
        ),
        centerTitle: true,
        actions: [
          Icon(
            widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.product.isFavorite ? AppTheme.primaryGreen : AppTheme.textDark,
            size: 24,
          ),
          const SizedBox(width: 16),
          const Icon(Icons.share_outlined, color: AppTheme.textDark, size: 24),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 400,
              color: AppTheme.borderGrey.withValues(alpha: 0.3),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 400,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_outlined,
                        size: 100,
                        color: AppTheme.textLightGrey,
                      ),
                    ),
                  ),
                  // Pagination dots
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_border, color: AppTheme.primaryGreen, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.rating.toString(),
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price Row
                  Row(
                    children: [
                      Text(
                        'Rs. ${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                              fontSize: 24,
                            ),
                      ),
                      if (widget.product.originalPrice != null) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Rs. ${widget.product.originalPrice!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textGrey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                        ),
                        if (discountText.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primaryGreen),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              discountText,
                              style: const TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ]
                      ]
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Colors
                  Text(
                    'COLOR',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(widget.product.colors.length, (index) {
                      final isSelected = _selectedColorIndex == index;
                      final color = widget.product.colors[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColorIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color == Colors.white ? AppTheme.borderGrey : Colors.transparent,
                            ),
                          ),
                          child: isSelected
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 12),
                                  ),
                                )
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Sizes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SIZE',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                      ),
                      Text(
                        'Size Guide',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryGreen,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(widget.product.sizes.length, (index) {
                      final isSelected = _selectedSizeIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSizeIndex = index;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGreen : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.product.sizes[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  const Divider(color: AppTheme.borderGrey),

                  // Description Expandable
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      iconColor: AppTheme.textDark,
                      collapsedIconColor: AppTheme.textDark,
                      title: Text(
                        'Product Description',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            widget.product.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: AppTheme.borderGrey),

                  // Shipping & Returns
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      iconColor: AppTheme.textDark,
                      collapsedIconColor: AppTheme.textDark,
                      title: Text(
                        'Shipping & Returns',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Standard shipping takes 3-5 business days. Free returns within 30 days.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppTheme.borderGrey),
                  const SizedBox(height: 80), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Add to Cart Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppTheme.borderGrey)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isAddingToCart
                ? null
                : () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please log in to add items to your cart.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    final messenger = ScaffoldMessenger.of(context);
                    setState(() => _isAddingToCart = true);

                    try {
                      final cartItem = CartItem(
                        id: '', // Firestore will generate ID
                        productId: widget.product.id,
                        productName: widget.product.name,
                        productPrice: widget.product.price,
                        productImageUrl: widget.product.imageUrl,
                        quantity: 1,
                        selectedSize: widget.product.sizes[_selectedSizeIndex],
                        selectedColor: widget.product.colors[_selectedColorIndex],
                      );

                      await _cartService.addToCart(user.uid, cartItem);

                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart successfully'),
                            backgroundColor: AppTheme.primaryGreen,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add to cart. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isAddingToCart = false);
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isAddingToCart
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'ADD TO CART — Rs. ${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
