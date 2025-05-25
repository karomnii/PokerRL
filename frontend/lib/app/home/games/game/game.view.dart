import 'package:flutter/material.dart';
import 'package:frontend/app/home/games/game/bet_button.dart';
import 'package:frontend/app/home/games/game/game.controller.dart';
import 'package:frontend/app/home/games/game/game_table.dart';
import 'package:frontend/app/home/games/game/player_card.dart';
import 'package:frontend/app/home/games/game_card.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_row.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:collection/collection.dart';

class GamePageView extends GetView<GamePageController> {
  const GamePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = 300.0;
    return ThemedScaffold(
      appBar: const ThemedAppBar(title: 'Games'),
      body: Obx(() {
        final err = controller.errorMessage.value;
        if (err != null) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Get.snackbar('Error', err, instantInit: false));
          controller.errorMessage.value = null;
        }

        if (controller.isInitialLoading.value) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Theme.of(context).primaryColor,
              secondRingColor: Theme.of(context).secondaryHeaderColor,
              thirdRingColor: Theme.of(context).cardTheme.color!,
              size: 200,
            ),
          );
        }

        return Obx(
          () => PageColumn(
            spacing: 1,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameTable(game: controller.gameState.value),
              PageRow(
                  spacing: 1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: PlayerCard(
                      currentSeatId:
                          controller.gameState.value.currentTurnUserId ?? 0,
                      seatId: 1,
                      player: controller.gameState.value.players
                          ?.singleWhereOrNull((p) => p.seatPosition == 1),
                      joinGame: () => controller.joinGame(1),
                      showHaveCards:
                          controller.gameState.value.playerCards?.isNotEmpty ??
                              false,
                    )),
                    Expanded(
                        child: PlayerCard(
                      currentSeatId:
                          controller.gameState.value.currentTurnUserId ?? 0,
                      player: controller.gameState.value.players
                          ?.singleWhereOrNull((p) => p.seatPosition == 2),
                      seatId: 2,
                      joinGame: () => controller.joinGame(2),
                      showHaveCards:
                          controller.gameState.value.playerCards?.isNotEmpty ??
                              false,
                    )),
                  ]),
              PageRow(
                  spacing: 1,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: PlayerCard(
                      currentSeatId:
                          controller.gameState.value.currentTurnUserId ?? 0,
                      player: controller.gameState.value.players
                          ?.singleWhereOrNull((p) => p.seatPosition == 3),
                      seatId: 3,
                      joinGame: () => controller.joinGame(3),
                      showHaveCards:
                          controller.gameState.value.playerCards?.isNotEmpty ??
                              false,
                    )),
                    Expanded(
                        child: PlayerCard(
                      currentSeatId:
                          controller.gameState.value.currentTurnUserId ?? 0,
                      player: controller.gameState.value.players
                          ?.singleWhereOrNull((p) => p.seatPosition == 4),
                      seatId: 4,
                      joinGame: () => controller.joinGame(4),
                      showHaveCards:
                          controller.gameState.value.playerCards?.isNotEmpty ??
                              false,
                    )),
                  ]),
              SizedBox(
                height: 20,
              ),
              PageRow(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (controller.gameState.value.currentState ?? '') ==
                        'Waiting'
                    ? [
                        ElevatedButton.icon(
                          onPressed:
                              (controller.gameState.value.players?.length ??
                                          0) >
                                      1
                                  ? () => controller.startGame()
                                  : null,
                          label: Text('Start'),
                          icon: Icon(Icons.start_sharp),
                        ),
                      ]
                    : [
                        // Check
                        ElevatedButton.icon(
                          onPressed:
                              controller.gameState.value.currentTurnUserId ==
                                          AuthService.to.userId &&
                                      (controller.gameState.value.callAmount ??
                                              0) ==
                                          0
                                  ? () => controller.makeMove('Check', 0)
                                  : null,
                          label: Text('Check'),
                          icon: Icon(Icons.pan_tool_alt_outlined),
                        ),
                        // Call
                        ElevatedButton.icon(
                          onPressed: controller
                                      .gameState.value.currentTurnUserId ==
                                  AuthService.to.userId
                              ? () => controller.makeMove(
                                    'Call',
                                    // <- MUSI pójść kwota do dopłacenia
                                    controller.gameState.value.callAmount ?? 0,
                                  )
                              : null,
                          label: const Text('Call'),
                          icon: const Icon(Icons.equalizer_sharp),
                        ),
                        // Bet
                        BetButtonWidget(
                          isEnabled: controller
                                      .gameState.value.currentTurnUserId ==
                                  AuthService.to.userId &&
                              controller.gameState.value.minRaiseAmount! <=
                                  controller.gameState.value.players!
                                      .singleWhere((p) =>
                                          p.userId == AuthService.to.userId)
                                      .currentChips!,
                          bet: controller.gameState.value.currentTurnUserId ==
                                      AuthService.to.userId &&
                                  (controller.gameState.value.callAmount ??
                                          0) ==
                                      0 &&
                                  controller.gameState.value.minRaiseAmount! <=
                                      controller.gameState.value.players!
                                          .singleWhere((p) =>
                                              p.userId! ==
                                              AuthService.to.userId!)
                                          .currentChips! &&
                                  controller.gameState.value.minRaiseAmount! <=
                                      controller.currentBet.value
                              ? () => controller.makeMove(
                                  'Bet', controller.currentBet.value)
                              : null,
                          addValue: () {
                            final chipsLeft = controller
                                .gameState.value.players!
                                .singleWhere(
                                    (p) => p.userId == AuthService.to.userId)
                                .currentChips!;
                            final next = controller.currentBet.value +
                                controller.gameState.value.minRaiseAmount!;
                            if (next <= chipsLeft) {
                              controller.currentBet.value = next;
                            }
                          },
                          removeValue: () {
                            final next = controller.currentBet.value -
                                controller.gameState.value.minRaiseAmount!;
                            // nie schodź poniżej minRaise
                            if (next >=
                                controller.gameState.value.minRaiseAmount!) {
                              controller.currentBet.value = next;
                            }
                          },
                          currentValue: controller.currentBet.value,
                          changeValue: (x) => controller.currentBet.value = x,
                        ),
                        // Raise
                        ElevatedButton.icon(
                          onPressed:
                              controller.gameState.value.currentTurnUserId ==
                                      AuthService.to.userId
                                  ? () => controller.makeMove(
                                        'Raise',
                                        controller.currentBet.value,
                                      )
                                  : null,
                          label: Text('Raise'),
                          icon: Icon(Icons.more_sharp),
                        ),
                        // AllIn
                        ElevatedButton.icon(
                          onPressed: controller
                                          .gameState.value.currentTurnUserId ==
                                      AuthService.to.userId &&
                                  controller.gameState.value.players!
                                          .singleWhere((p) =>
                                              p.userId! ==
                                              AuthService.to.userId!)
                                          .currentChips! >
                                      0
                              ? () => controller.makeMove(
                                  'AllIn',
                                  controller.gameState.value.players!
                                      .singleWhere((p) =>
                                          p.userId! == AuthService.to.userId!)
                                      .currentChips!)
                              : null,
                          label: Text('All In'),
                          icon: Icon(Icons.flash_on_outlined),
                        ),
                        // Fold
                        ElevatedButton.icon(
                          onPressed: controller
                                      .gameState.value.currentTurnUserId ==
                                  AuthService.to.userId
                              ? () => controller.makeMove('Fold',
                                  controller.gameState.value.minRaiseAmount!)
                              : null,
                          label: Text('Fold'),
                          icon: Icon(Icons.stop_sharp),
                        ),
                      ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
