import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_row.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Home Page',
        actions: [
          AppBarIcon(
            icon: Icons.casino,
            tooltipText: 'Play',
            onPressed: () => Get.offNamed('/game', preventDuplicates: false),
          ),
          AppBarIcon(
            icon: Icons.store,
            tooltipText: 'Shop',
            onPressed: () {},
          ),
          AppBarIcon(
            icon: Icons.person,
            tooltipText: 'Account',
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
          child: PageCard(
        title: '',
        child: PageColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Giga AI Casino'),
            Image.asset(
              width: 500,
              'dices.png',
              scale: 0.2,
              fit: BoxFit.contain,
            ),
            const PageRow(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: null,
                  child: Text('Elevated'),
                ),
              ],
            ),
            PageRow(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
