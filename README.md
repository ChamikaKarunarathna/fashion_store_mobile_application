# CK Mart - Fashion Store Mobile Application

A modern, feature-rich Flutter mobile application for an online fashion store. CK Mart provides a seamless shopping experience on iOS and Android platforms with user authentication, product browsing, cart management, and a complete checkout workflow.

## Project Overview

CK Mart is a mobile e-commerce application designed to showcase a fashion product catalog. The app features an intuitive user interface built with Flutter, allowing users to browse collections, view detailed product information, manage shopping carts, and complete purchases. The application is built with clean architecture principles, separating concerns into screens, models, widgets, and utilities.

**Target Platforms:** iOS, Android, Web, Linux, macOS, Windows

## Features

- **User Authentication**: Login screen for secure user access
- **Product Browsing**: Browse fashion products organized in collections
- **Product Details**: Detailed view with comprehensive product information
- **Shopping Cart**: Add/remove items and manage quantities
- **Checkout Process**: Complete order checkout workflow
- **User Profile**: Manage user account and preferences
- **Custom Theme**: Consistent, modern UI with custom theme configuration
- **Responsive Design**: Optimized layouts for various screen sizes
- **Google Fonts Integration**: Professional typography using Google Fonts

## Prerequisites/Requirements

### System Requirements
- **Flutter SDK**: ^3.11.1
- **Dart**: Included with Flutter (^3.11.1 or higher)
- **Disk Space**: Minimum 2GB free space for Flutter SDK and dependencies
- **RAM**: 4GB minimum recommended
- **Internet Connection**: Required for package downloads

### Platform-Specific Requirements

**iOS:**
- macOS 11 or later with Xcode 13 or later
- iOS 11.0 or higher as target
- CocoaPods package manager

**Android:**
- Android SDK API level 21 or higher
- Android Gradle Plugin 7.0 or higher
- Java Development Kit (JDK) 11 or higher

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/fashion_store_mobile_application.git
cd fashion_store_mobile_application
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Build Icons/Launcher Icons (Optional)

```bash
flutter pub run flutter_launcher_icons:main
```

### 4. Run the Application

**On iOS:**
```bash
flutter run -d ios
```

**On Android:**
```bash
flutter run -d android
```

**On Web:**
```bash
flutter run -d web
```

### 5. Build for Release

**iOS:**
```bash
flutter build ios --release
```

**Android:**
```bash
flutter build apk --release
```

**Web:**
```bash
flutter build web
```

## Project Structure

```
lib/
├── main.dart                    # Application entry point
├── screens/                     # All UI screens
│   ├── login_screen.dart       # User authentication screen
│   ├── home_screen.dart        # Main/home screen
│   ├── collection_screen.dart  # Product collection view
│   ├── product_details_screen.dart  # Detailed product view
│   ├── cart_screen.dart        # Shopping cart management
│   ├── checkout_screen.dart    # Order checkout flow
│   └── profile_screen.dart     # User profile management
├── models/                      # Data models
│   ├── product.dart            # Product data model
│   └── cart_item.dart          # Shopping cart item model
├── widgets/                     # Reusable UI components
│   └── product_card.dart       # Product display card widget
├── theme/                       # Application theming
│   └── app_theme.dart          # Custom theme configuration
└── utils/                       # Utility functions and data
    └── dummy_data.dart         # Mock data for development

android/                         # Android platform-specific code
ios/                            # iOS platform-specific code
web/                            # Web platform-specific code
linux/                          # Linux platform-specific code
macos/                          # macOS platform-specific code
windows/                        # Windows platform-specific code
test/                           # Unit and widget tests
assets/
└── images/                     # Image assets (logos, product images)
```

## Usage

### Starting the Application

1. **Launch the app** - The app opens to the login screen
2. **Login** - Complete user authentication
3. **Browse Products** - Navigate through collections and view available items
4. **View Details** - Tap on a product to see detailed information
5. **Add to Cart** - Add items to your shopping cart from the product details
6. **Manage Cart** - Review items in your cart, adjust quantities, or remove items
7. **Checkout** - Proceed to checkout to complete your purchase
8. **View Profile** - Access your profile to manage account settings

### Navigation Flow

```
LoginScreen → HomeScreen → [CollectionScreen / ProductDetailsScreen]
                    ↓
                  CartScreen → CheckoutScreen
                    ↓
                ProfileScreen
```

### Key Components

**Screens** contain full-page UI implementations  
**Models** define data structures for Products and Cart Items  
**Widgets** are reusable UI components (e.g., ProductCard)  
**Theme** centralizes style definitions for consistent appearance  
**Utils** provides mock data and helper functions  

## Technologies Used

- **Framework**: Flutter 3.11.1+
- **Language**: Dart
- **UI Components**: Material Design
- **Typography**: Google Fonts 8.0.2+
- **Icons**: Cupertino Icons 1.0.8+
- **Development Tools**: Flutter Launcher Icons

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

Copyright © 2026 Chamika Karunarathna

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Best Practices](https://docs.flutter.dev/testing/best-practices)
