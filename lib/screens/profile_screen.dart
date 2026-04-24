import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'cart_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _bottomNavIndex = 3; // Profile is index 3

  void _onBottomNavTapped(int index) {
    if (index == _bottomNavIndex) return;
    
    // Simple navigation for demo purposes
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // No back button on root profile
        title: Text(
          'MY PROFILE',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.settings_outlined, color: AppTheme.textDark, size: 24),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Info
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.borderGrey,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/profile_1.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 50, color: AppTheme.textLightGrey);
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Jane Alexander',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'jane.alexander@example.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Gold Member',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(color: AppTheme.borderGrey, height: 1),

            // Account Settings
            _buildSectionHeader('ACCOUNT SETTINGS'),
            _buildListTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Name, Email, Profile Picture',
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),
            _buildListTile(
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              subtitle: 'View and track your previous orders',
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),
            _buildListTile(
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              subtitle: 'Manage your delivery locations',
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),

            // Preferences
            _buildSectionHeader('PREFERENCES'),
            _buildListTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage alerts and updates',
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),
            _buildListTile(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Password and data settings',
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),

            // Log Out
            const SizedBox(height: 8),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.red),
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
              onTap: () {
                // Log out logic
              },
            ),
            const Divider(color: AppTheme.borderGrey, height: 1),

            // Footer Version
            const SizedBox(height: 32),
            Text(
              'CK MART V1.2.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLightGrey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLightGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.borderGrey.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryGreen),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppTheme.textDark,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 12,
          ),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textGrey),
      onTap: () {
        // Navigate
      },
    );
  }
}
