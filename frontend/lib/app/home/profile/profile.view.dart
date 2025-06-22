import 'package:flutter/material.dart';
import 'package:frontend/app/home/profile/avatar_list.dart';
import 'package:frontend/app/home/profile/cards_list.dart';
import 'package:frontend/app/home/profile/profile.controller.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_row.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Profile Page',
        actions: [
          AppBarIcon(
            icon: Icons.casino,
            tooltipText: 'Play',
            onPressed: () => Get.offAndToNamed('/game'),
          ),
          AppBarIcon(
            icon: Icons.store,
            tooltipText: 'Shop',
            onPressed: () => Get.toNamed('/shop', preventDuplicates: false),
          ),
          AppBarIcon(
            icon: Icons.home,
            tooltipText: 'Home',
            onPressed: () => Get.offAndToNamed('/'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Obx(() {
            final user = controller.user.value;
            if (user == null) {
              return SizedBox.shrink();
            }

            return Column(
              children: [
                PageCard(
                  title: 'User Profile',
                  child: PageColumn(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Obx(() {
                          final avatar = controller.userAvatar.value;

                          if (avatar == null) {
                            return const CircularProgressIndicator();
                          }

                          return CircleAvatar(
                            radius: 80,
                            backgroundImage: avatar,
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      Text('Username: ${user?.username}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Email: ${user?.email}',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Chips Balance: ${user?.chipsBalance}',
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                if (controller.avatars.isNotEmpty)
                  AvatarList(
                    items: controller.avatars,
                    ava: user?.avatarImage ?? '',
                    onItemSelect: controller.setItem,
                  ),
                if (controller.cards.isNotEmpty)
                  CardsList(
                    items: controller.cards,
                    deck: user?.deckStyle ?? '',
                    onItemSelect: controller.setItem,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
