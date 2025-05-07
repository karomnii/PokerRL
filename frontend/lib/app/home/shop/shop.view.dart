import 'package:flutter/material.dart';
import 'package:frontend/app/home/shop/shop.controller.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';

class ShopPageView extends GetView<ShopPageController> {
  const ShopPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Shop Page',
        actions: [
          AppBarIcon(
            icon: Icons.casino,
            tooltipText: 'Play',
            onPressed: () => Get.offAndToNamed('/game'),
          ),
          AppBarIcon(
            icon: Icons.home,
            tooltipText: 'Home',
            onPressed: () => Get.offAndToNamed('/'),
          ),
          AppBarIcon(
            icon: Icons.person,
            tooltipText: 'Account',
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: controller.categorizedProducts.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: PageCard(
                    title: '',
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: entry.value.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: PageCard(
                          title: '',
                          child: Column(
                            children: [
                              Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: context.theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        );
      }),
    );
  }
}
