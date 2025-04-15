import 'dart:math';
import 'package:get/get.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String category;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

class ShopPageController extends GetxController {
  final RxMap<String, List<Product>> categorizedProducts =
      <String, List<Product>>{}.obs;

  final List<String> categories = ['Cards', 'Dices', 'Tables'];

  final int itemCount = 100; // 🛠️ Możesz łatwo zmienić ilość

  @override
  void onInit() {
    super.onInit();
    _generateMockData();
  }

  void _generateMockData() {
    final random = Random();

    final products = List.generate(itemCount, (index) {
      final category = categories[random.nextInt(categories.length)];
      return Product(
        name: '${category.substring(0, category.length - 1)} #${index + 1}',
        imageUrl:
            'https://picsum.photos/200/125?random=${index + random.nextInt(1000)}',
        price: (5 + random.nextDouble() * 45).toPrecision(2),
        category: category,
      );
    });

    categorizedProducts.clear();
    for (var category in categories) {
      categorizedProducts[category] =
          products.where((p) => p.category == category).toList();
    }
  }
}
