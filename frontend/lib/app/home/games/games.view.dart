import 'package:flutter/material.dart';
import 'package:frontend/app/home/games/games.controller.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';

class GamesPageView extends GetView<GamesPageController> {
  const GamesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Games',
        actions: [
          AppBarIcon(
            icon: Icons.home,
            tooltipText: 'Home',
            onPressed: () => Get.offNamed('/', preventDuplicates: false),
          ),
          AppBarIcon(
            icon: Icons.store,
            tooltipText: 'Shop',
            onPressed: () => Get.toNamed('/shop', preventDuplicates: false),
          ),
          PopupMenuButton<String>(
            icon: Tooltip(
              message: 'Account',
              child: const Icon(
                Icons.person,
                size: 36.0,
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  AuthService.to.logout();
                  Get.offAllNamed('/');
                  break;
                case 'login':
                  Get.toNamed('/auth/');
                  break;
                case 'register':
                  Get.toNamed('/auth/register');
                  break;
              }
            },
            itemBuilder: (context) {
              final loggedIn = AuthService.to.isLoggedIn;
              return loggedIn
                  ? [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]
                  : [
                      const PopupMenuItem(
                        value: 'login',
                        child: Text('Login',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'register',
                        child: Text('Register',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ];
            },
          ),
        ],
      ),
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
            width: 620.0,
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
                              constraints: BoxConstraints(maxHeight: 120),
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
                                    DataColumn(
                                      label: const Text('Difficulty'),
                                      onSort: (columnIndex, ascending) {
                                        controller.sortColumnIndex.value =
                                            columnIndex;
                                        controller.sortAscending.value =
                                            ascending;

                                        controller.games.sort((a, b) {
                                          final aDiff = a.tableDifficulty ?? '';
                                          final bDiff = b.tableDifficulty ?? '';
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
                                    return DataRow(cells: [
                                      DataCell(Text(game.gameId.toString())),
                                      DataCell(
                                          Text(game.tableName ?? 'Unknown')),
                                      DataCell(Obx(() {
                                        final count =
                                            controller.activePlayersCount[
                                                    game.gameId!] ??
                                                0;
                                        return Text('$count/4');
                                      })),
                                      DataCell(
                                        Padding(
                                          padding: const EdgeInsets.all(0.5),
                                          child: FilledButton.icon(
                                            icon: const Icon(
                                                Icons.play_arrow_sharp),
                                            onPressed: () {
                                              controller.joinGame(game);
                                            },
                                            label: const Text('Join'),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          )),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
