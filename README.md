# Food Delivery App

A modern Flutter application for food delivery services, allowing users to browse food items, add them to cart, and place orders.

## Screenshots

![food_app1](https://github.com/Paolo068/food_app/assets/60113185/51477ece-67f3-4596-9ec0-6f8c76e3e69d)
![food_app2](https://github.com/Paolo068/food_app/assets/60113185/11b4cc56-4883-4d44-a18e-6c153e1e88fc)
![food_app3](https://github.com/Paolo068/food_app/assets/60113185/03683c9d-a92d-4d24-9681-aca6212ca18f)
![food_app4](https://github.com/Paolo068/food_app/assets/60113185/e4a0c4cb-abcc-4961-9148-1729209344a8)
![food_app5](https://github.com/Paolo068/food_app/assets/60113185/bd920625-0d38-44d3-a5f9-2bee1ee67bd4)
![food_app6](https://github.com/Paolo068/food_app/assets/60113185/b4013433-cc38-4335-b851-263cdeb1c7d8)
![food_app7](https://github.com/Paolo068/food_app/assets/60113185/2569c738-f943-4398-b02d-7ad8365132d0)
![food_app8](https://github.com/Paolo068/food_app/assets/60113185/ae3fb6b6-daa9-4604-9a17-d13cb4c1abfe)

## Key Features

- **Product Browsing**: View available food items with images, descriptions, and prices
- **Search Functionality**: Filter products by name
- **Cart Management**: Add items to cart, modify quantities, and remove items
- **Add-ons Support**: Customize orders with additional options
- **Order Placement**: Complete the ordering process
- **Responsive UI**: Works across different device sizes
- **Offline Support**: Local data storage with Hive

## Technologies Used

- **Flutter**: UI framework for cross-platform development
- **Riverpod**: State management solution
- **Hive**: Local database for offline storage
- **Dio**: HTTP client for API requests
- **Cached Network Image**: Efficient image loading and caching
- **Flutter SVG**: SVG rendering support
- **Google Fonts**: Typography customization

## Project Structure

```
lib/
├── core/
│   ├── models/         # Data models
│   ├── shared_widgets/ # Reusable UI components
│   └── theme/          # App theming
├── features/
│   ├── cart/           # Cart functionality
│   ├── home/           # Home page
│   ├── order/          # Order processing
│   ├── product/        # Product display
│   └── product_addon/  # Add-on functionality
└── main.dart           # Application entry point
```

## Setup and Installation

### Prerequisites

- Flutter SDK (>=3.1.4)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions

### Installation Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/food_app.git
   cd food_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## API Integration

The app connects to a backend API for product data. The base URL is defined in `AppConstants.baseUrl`. Product images are accessed via `${AppConstants.baseUrl}/assets/${item.image}`.

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  flutter_svg: ^2.0.9
  gap: ^3.0.1
  dio: ^5.4.1
  logger: ^2.0.2+1
  flutter_riverpod: ^2.5.1
  hive_flutter: ^1.1.0
  hive: ^2.2.3
  fluttertoast: ^8.2.4
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  riverpod_lint: ^2.3.7
  custom_lint: ^0.5.7
```

## Platform Support

- Android
- iOS
- Web
- Linux

## License

[Add your license information here]

## Contributors

[Add contributor information here]
