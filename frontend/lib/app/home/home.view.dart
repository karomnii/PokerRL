import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:frontend/widgets/app_bar.dart';
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
      appBar: const ThemedAppBar(
        title: 'Home Page',
      ),
      body: Center(
          child: PageCard(
        title: '',
        child: PageColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              width: 200,
              'poker.png',
              scale: 0.2,
              fit: BoxFit.contain,
            ),
            PageRow(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
