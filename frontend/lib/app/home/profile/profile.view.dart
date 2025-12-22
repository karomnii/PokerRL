import 'package:flutter/material.dart';
import 'package:frontend/app/home/profile/avatar_tile.dart';
import 'package:frontend/app/home/profile/cards_tile.dart';
import 'package:frontend/app/home/profile/profile.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Profile',
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
      body: Obx(() {
        if (controller.user.value == null) {
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
                  _buildTabText(context, 'Profile', 0),
                  const SizedBox(width: 24),
                  _buildTabText(context, 'Avatars', 1),
                  const SizedBox(width: 24),
                  _buildTabText(context, 'Decks', 2),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final listHeight = constraints.maxHeight - 100;
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
          key: const ValueKey('ProfileTab'),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: _buildProfileInfoView(),
        );
      case 1:
        return SizedBox(
          key: const ValueKey('AvatarsTab'),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: _buildAvatarsView(safeHeight),
        );
      case 2:
        return SizedBox(
          key: const ValueKey('DecksTab'),
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

  Widget _buildProfileInfoView() {
    final user = controller.user.value!;
    return Center(
      child: PageCard(
        title: 'User Details',
        margin: 4,
        padding: 16,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepPurple, width: 2),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 6,
                            spreadRadius: 1)
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey.shade900,
                      backgroundImage: controller.userAvatar.value,
                      child: controller.userAvatar.value == null
                          ? const Icon(Icons.person,
                              size: 35, color: Colors.white24)
                          : null,
                    ),
                  )),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.email!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '${user.chipsBalance ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => controller.addChips(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(60, 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("+1k",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarsView(double height) {
    final avatars = controller.avatars;
    return PageCard(
      title: 'My Avatars',
      margin: 4,
      padding: 4,
      child: SizedBox(
        height: height,
        child: avatars.isEmpty
            ? const Center(
                child: Text("No avatars purchased yet.",
                    style: TextStyle(color: Colors.white38)))
            : GridView.builder(
                padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: avatars.length,
                itemBuilder: (_, i) => AvatarProfileTile(
                  avatars[i],
                  ava: controller.activeAvatarName.value,
                  onItemSelect: controller.setItem,
                ),
              ),
      ),
    );
  }

  Widget _buildDecksView(double height) {
    final cards = controller.cards;
    return PageCard(
      title: 'My Decks',
      margin: 2,
      padding: 2,
      child: SizedBox(
        height: height,
        child: cards.isEmpty
            ? const Center(
                child: Text("No decks purchased yet.",
                    style: TextStyle(color: Colors.white38)))
            : GridView.builder(
                padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.75,
                ),
                itemCount: cards.length,
                itemBuilder: (_, i) => CardDeckProfileTile(
                  cards[i],
                  controller.activeDeckName.value,
                  onItemSelect: controller.setItem,
                ),
              ),
      ),
    );
  }
}
