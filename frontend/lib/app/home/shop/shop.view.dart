import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:frontend/app/home/shop/shop.controller.dart';
import 'package:frontend/app/home/shop/avatar_tile.dart';
import 'package:frontend/app/home/shop/card_deck_tile.dart';

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
            onPressed: () => Get.offAndToNamed('/profile'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Theme.of(context).primaryColor,
              secondRingColor: Theme.of(context).secondaryHeaderColor,
              thirdRingColor: Theme.of(context).cardTheme.color!,
              size: 200,
            ),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;

        final avatarCrossAxisCount = (screenWidth / 100).clamp(3, 8).floor();
        final deckCrossAxisCount = (screenWidth / 180).clamp(2, 4).floor();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Avatars', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.avatars.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: avatarCrossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, i) => AvatarTile(controller.avatars[i]),
              ),
              const SizedBox(height: 32),
              Text('Decks', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.cards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deckCrossAxisCount,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  // CardDeckTile ma ok. 260 (wys) × 170 (szer)
                  childAspectRatio: 170 / 180,
                ),
                itemBuilder: (_, i) => CardDeckTile(controller.cards[i]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
