import 'dart:async'; // <-- NEW
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:get/get.dart';

class GamePageController extends GetxController {
  /* -------- konfiguracja pollingu -------- */
  static const Duration _pollInterval = Duration(seconds: 2);

  /* -------- stan -------- */
  final Rx<GameStateDto> gameState = GameStateDto().obs;

  final RxInt currentBet = 0.obs;
  // Spin-bar tylko przy pierwszym wczytaniu
  final RxBool isInitialLoading = false.obs;

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
