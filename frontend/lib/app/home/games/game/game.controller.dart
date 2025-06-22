import 'dart:async'; // <-- NEW
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:frontend/services/profile.service.dart';
import 'package:get/get.dart';

class GamePageController extends GetxController {
  ScrollController scrollController = ScrollController();
  final RxMap<int, UserDto> userInfos = <int, UserDto>{}.obs;
  /* -------- konfiguracja pollingu -------- */
  static const Duration _pollInterval = Duration(seconds: 2);

  /* -------- stan -------- */
  final Rx<GameStateDto> gameState = GameStateDto().obs;

  final RxInt currentBet = 0.obs;
  // Spin-bar tylko przy pierwszym wczytaniu
  final RxBool isInitialLoading = false.obs;

  int get buyIn => gameState.value.tableId == 1
      ? 1000
      : gameState.value.tableId == 2
          ? 5000
          : 10000;
  bool get isGameOver => gameState.value.currentState == 'Completed';
  bool get isGameWaiting => gameState.value.currentState == 'Waiting';
  // Dyskretny „refresh” – np. do pull-to-refresh albo ikonki odświeżania
  final RxBool isRefreshing = false.obs;

  final RxnString errorMessage = RxnString();

  /* -------- timer -------- */
  Timer? _pollTimer;

  /* ===== lifecycle ===== */

  @override
  void onReady() {
    super.onReady();
    getGame(firstLoad: true); // pierwszy strzał
    _startPolling(); // cykliczne odświeżanie
  }

  @override
  void onClose() {
    _stopPolling(); // ważne!
    super.onClose();
  }

  /* ===== API calls ===== */

  Future<void> getGame({bool firstLoad = false}) async {
    // pokazywanie loadera w zależności od kontekstu
    if (firstLoad) {
      isInitialLoading.value = true;
    } else {
      isRefreshing.value = true;
    }

    try {
      final gameId = int.parse(Uri.base.pathSegments[1]);
      final result = await GameService.to.getGame(gameId);
      gameState.value = result;
      if (currentBet.value == 0) {
        currentBet.value = result.minRaiseAmount ?? currentBet.value;
      }
      final playerIds =
          result.players?.map((p) => p.userId).whereType<int>().toSet() ?? {};

      for (final id in playerIds) {
        if (!userInfos.containsKey(id)) {
          try {
            final profile = await ProfileService.to
                .fetchProfileId(id); // <- Dodaj metodę poniżej
            userInfos[id] = profile;
          } catch (e) {
            // np. print lub ignoruj
          }
        }
      }
    } catch (e, s) {
      errorMessage.value = e.toString();
      // logować stacktrace jeśli potrzeba:
      // debugPrintStack(stackTrace: s);
    } finally {
      if (firstLoad) {
        isInitialLoading.value = false;
      } else {
        isRefreshing.value = false;
      }
    }
  }

  Future<void> joinGame(int seatPosition) async {
    try {
      await GameService.to.joinGame(
        JoinGameDto(
          seatPosition: seatPosition,
          buyInAmount: 1000,
        ),
        gameState.value.gameId!,
        AuthService.to.userId!,
      );
      await getGame();
    } finally {}
  }

  Future<void> startGame() async {
    try {
      await GameService.to.startGame(
        gameState.value.gameId!,
      );
      await getGame();
    } finally {}
  }

  Future<void> makeMove(String actionType, int amount) async {
    try {
      await GameService.to.makeMove(
          gameState.value.gameId!, AuthService.to.userId!, actionType, amount);
      await getGame();
    } finally {}
  }

  Future<void> leaveGame() async {
    try {
      final gameId = gameState.value.gameId!;
      final userId = AuthService.to.userId!;
      await GameService.to.leaveGame(gameId, userId);
    } finally {}
  }

  Future<List<AgentDto>> getBots() async {
    try {
      final gameId = gameState.value.gameId!;
      return await GameService.to.getBots(gameId);
    } finally {}
  }

  Future<void> addBot(int gameId, int agentId, JoinGameDto body) async {
    try {
      final gameId = gameState.value.gameId!;
      GameService.to.addBot(gameId, agentId, body);
    } finally {}
  }

  Future<void> getHint() async {
    try {
      final gameId = gameState.value.gameId!;
      final hints =
          await GameService.to.getHint(gameId, AuthService.to.userId!);

      final messageWidgets = hints
          .map(
            (h) => Row(
              children: [
                Image.asset(
                  'assets/be/avatars/${h.modelName == 'Stupid' ? 'Lollipop.png' : h.modelName == 'Aggressive' ? 'Pumpkin.png' : 'Cat.png'}',
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${h.modelName} ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'says: '),
                        TextSpan(
                          text: h.move,
                          style: TextStyle(color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList();

      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundGradient: LinearGradient(
          colors: [Color(0xFF121112), Color(0xFF121112)],
        ),
        borderRadius: 16,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 8),
        padding: EdgeInsets.all(16),
        messageText: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🤖 Bots are saying...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            ...messageWidgets,
          ],
        ),
      );
    } catch (e) {
      Get.snackbar('Oops!', 'Nie udało się pobrać podpowiedzi 😢');
    }
  }

  /* ===== polling utils ===== */

  void _startPolling() {
    _pollTimer?.cancel(); // zapobiegawczo
    _pollTimer = Timer.periodic(
      _pollInterval,
      (_) => getGame(),
    );
  }

  void _stopPolling() => _pollTimer?.cancel();
}
