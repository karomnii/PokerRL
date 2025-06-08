import 'package:flutter/material.dart';
import 'package:frontend/app/home/profile/profile.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
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
      appBar: ThemedAppBar(title: 'Profile Page'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Obx(() {
            final user = controller.user.value;

            if (user == null) {
              return const CircularProgressIndicator();
            }
            return PageCard(
              title: 'User Profile',
              child: PageColumn(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          AssetImage(user.avatarImage ?? 'assets/avatar.png'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Username: ${user.username}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Chips Balance: ${user.chipsBalance}',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
