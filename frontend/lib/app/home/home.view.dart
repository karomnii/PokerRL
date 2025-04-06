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
        child: IntrinsicWidth(
          child: PageColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageRow(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('AI Casino',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: 50,
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              Image.asset(
                width: 500,
                'dices.png',
                scale: 0.2,
                fit: BoxFit.contain,
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    Get.offNamed('/game', preventDuplicates: false),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
              PageRow(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Sign In'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add),
                      label: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
