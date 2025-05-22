import 'package:flutter/material.dart';
import 'package:frontend/app/home/games/games.controller.dart';
import 'package:frontend/app/home/games/game_card.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/cards/playing_card.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GamesPageView extends GetView<GamesPageController> {
  const GamesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: const ThemedAppBar(title: 'Games'),
      body: Obx(() {
        final err = controller.errorMessage.value;
        if (err != null) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Get.snackbar('Error', err, instantInit: false));
          controller.errorMessage.value = null; // clear
        }

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

        return SizedBox(
          width: double.infinity,
          child: PageCard(
            title: 'Games',
            titleExtras: [
              ElevatedButton.icon(
                onPressed: () => controller.createGame(),
                icon: const Icon(
                  Icons.add_sharp,
                  size: 25,
                ),
                label: const Text('Create game'),
              ),
            ],
            child: controller.games.isEmpty
                ? const Text('No games available!')
                : SizedBox(
                    child: DataTable(
                      showBottomBorder: true,
                      columns: const [
                        DataColumn(label: Text('Game ID')),
                        DataColumn(label: Text('Owner')),
                        DataColumn(label: Text('')),
                      ],
                      rows: controller.games.map((game) {
                        final ownerName = game.gamePlayers
                                ?.firstWhereOrNull((gp) => gp.isActive ?? false)
                                ?.user
                                ?.username ??
                            'Unknown';

                        return DataRow(cells: [
                          DataCell(Text(game.gameId.toString())),
                          DataCell(Text(ownerName)),
                          DataCell(
                            FilledButton.icon(
                              icon: Icon(Icons.play_arrow_sharp),
                              onPressed: () {
                                controller.joinGame(game);
                              },
                              label: const Text('Join'),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
