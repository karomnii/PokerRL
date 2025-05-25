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
    final theme = Theme.of(context);
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

        return Center(
          child: SizedBox(
            width: 800.0,
            child: PageCard(
              title: 'Games',
              titleExtras: [
                Obx(
                  () => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DropdownMenu<int>(
                      initialSelection: controller.selectedTableId.value,
                      onSelected: (value) {
                        if (value != null) {
                          controller.selectedTableId.value = value;
                        }
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(
                          value: 1,
                          label: 'Beginner',
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              ThemeData.light().colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: 2,
                          label: 'Intermediate',
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              ThemeData.light().colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        DropdownMenuEntry(
                          value: 3,
                          label: 'Pro',
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              ThemeData.light().colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => controller.createGame(),
                  icon: const Icon(Icons.add_sharp, size: 25),
                  label: const Text('Create game'),
                ),
              ],
              child: controller.games.isEmpty
                  ? const Text('No games available!')
                  : SizedBox(
                      child: Obx(() => Theme(
                            data: theme.copyWith(
                              iconTheme:
                                  theme.iconTheme.copyWith(color: Colors.white),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 400),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                controller: ScrollController(),
                                child: DataTable(
                                  showBottomBorder: true,
                                  sortColumnIndex:
                                      controller.sortColumnIndex.value,
                                  sortAscending: controller.sortAscending.value,
                                  columns: [
                                    const DataColumn(label: Text('Game ID')),
                                    const DataColumn(label: Text('Owner')),
                                    DataColumn(
                                      label: const Text('Difficulty'),
                                      onSort: (columnIndex, ascending) {
                                        controller.sortColumnIndex.value =
                                            columnIndex;
                                        controller.sortAscending.value =
                                            ascending;

                                        controller.games.sort((a, b) {
                                          final aDiff =
                                              a.table?.difficultyLevel ?? '';
                                          final bDiff =
                                              b.table?.difficultyLevel ?? '';
                                          return ascending
                                              ? aDiff.compareTo(bDiff)
                                              : bDiff.compareTo(aDiff);
                                        });
                                      },
                                    ),
                                    const DataColumn(label: Text('Players')),
                                    const DataColumn(label: Text('')),
                                  ],
                                  rows: controller.games.map((game) {
                                    final ownerName = game.gamePlayers
                                            ?.firstWhereOrNull(
                                                (gp) => gp.isActive ?? false)
                                            ?.user
                                            ?.username ??
                                        'Unknown';

                                    return DataRow(cells: [
                                      DataCell(Text(game.gameId.toString())),
                                      DataCell(Text(ownerName)),
                                      DataCell(Text(
                                          game.table?.difficultyLevel ??
                                              'Unknown')),
                                      DataCell(Text(
                                          '${game.gamePlayers?.length ?? 0}/4')),
                                      DataCell(
                                        FilledButton.icon(
                                          icon: const Icon(
                                              Icons.play_arrow_sharp),
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
                          ))),
            ),
          ),
        );
      }),
    );
  }
}
