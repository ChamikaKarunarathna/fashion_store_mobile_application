import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/dummy_data.dart';
import '../widgets/product_card.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  int _bottomNavIndex = 1; // Default to Search as per screenshot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, size: 20),
                  ),
                  Text(
                    'COLLECTION',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                  ),
                  const Icon(Icons.tune, size: 24),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Items Found and Sort Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DummyData.collectionProducts.length} ITEMS FOUND',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textGrey,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.swap_vert, size: 16, color: AppTheme.textDark),
                              const SizedBox(width: 4),
                              Text(
                                'Sort: Newest',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    SizedBox(
                      height: 32,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          _buildFilterChip('All Items', isSelected: true),
                          const SizedBox(width: 8),
                          _buildFilterChip('Category', hasDropdown: true),
                          const SizedBox(width: 8),
                          _buildFilterChip('Price', hasDropdown: true),
                          const SizedBox(width: 8),
                          _buildFilterChip('Size', hasDropdown: true),
                          const SizedBox(width: 8),
                          _buildFilterChip('Color', hasDropdown: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55, // Adjusted to fit original price
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: DummyData.collectionProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: DummyData.collectionProducts[index],
                            onTap: () {
                              // Navigate to details
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // End of Collection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(color: AppTheme.borderGrey)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'END OF COLLECTION',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textLightGrey,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppTheme.borderGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.textGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false, bool hasDropdown = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryGreen : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.borderGrey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: AppTheme.textGrey),
          ]
        ],
      ),
    );
  }
}
