import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/home/shop/shop.controller.dart';
import 'package:frontend/app/home/shop/avatar_tile.dart';
import 'package:frontend/app/home/shop/card_deck_tile.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';

class ShopPageView extends GetView<ShopPageController> {
  const ShopPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Shop',
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
          return const Center(child: CircularProgressIndicator());
        }
        final currentTabIdx = controller.currentTab.value;

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabText(context, 'Avatars', 0),
                  const SizedBox(width: 24),
                  _buildTabText(context, 'Decks', 1),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final listHeight = constraints.maxHeight - 120;
                    final safeHeight = listHeight > 0 ? listHeight : 0.0;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _buildBodyContent(
                          currentTabIdx, safeHeight, constraints),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
    );
  }

  Widget _buildBodyContent(
      int tabIndex, double safeHeight, BoxConstraints constraints) {
    switch (tabIndex) {
      case 0:
        return SizedBox(
          key: const ValueKey('ShopAvatarsTab'),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: _buildAvatarsView(safeHeight),
        );
      case 1:
        return SizedBox(
          key: const ValueKey('ShopDecksTab'),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: _buildDecksView(safeHeight),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTabText(BuildContext context, String text, int index) {
    return GestureDetector(
      onTap: () => controller.switchTab(index),
      behavior: HitTestBehavior.translucent,
      child: Obx(() {
        final isSelected = controller.currentTab.value == index;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  )
                : const Border(
                    bottom: BorderSide(color: Colors.transparent, width: 3)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white38,
              fontSize: 16,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAvatarsView(double height) {
    return PageCard(
      title: 'Avatars Collection',
      margin: 4,
      padding: 4,
      child: SizedBox(
        height: height,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: controller.avatars.length,
          itemBuilder: (_, i) => AvatarTile(
            controller.avatars[i],
            buy: controller.buyAnItem,
          ),
        ),
      ),
    );
  }

  Widget _buildDecksView(double height) {
    return PageCard(
      title: 'Card Decks',
      margin: 2,
      padding: 2,
      child: SizedBox(
        height: height,
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.75,
          ),
          itemCount: controller.cards.length,
          itemBuilder: (_, i) => CardDeckTile(
            controller.cards[i],
            buy: controller.buyAnItem,
          ),
        ),
      ),
    );
  }
}
