import 'package:flutter/material.dart';
import 'package:frontend/app/game/game.controller.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:frontend/widgets/cards/playing_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class GamePageView extends GetView<GamePageController> {
  const GamePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: const ThemedAppBar(
        title: 'Game',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.textEditingController,
            ),
            FilledButton(
              onPressed: () {
                controller.addCard(controller.textEditingController.text);
                controller.textEditingController.clear();
              },
              child: const Text('Dodaj'),
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.cardAssets.map((asset) {
                  return PlayingCard(frontAsset: asset);
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
