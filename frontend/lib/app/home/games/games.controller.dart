import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:get/get.dart';

class GamesPageController extends GetxController {
  final RxList<Game> games = <Game>[].obs;
  final RxBool isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onReady() {
    super.onReady();
    loadGames();
  }

  Future<void> loadGames() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      final result = await GameService.to.getGames();
      games.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createGame() async {
    try {
      isLoading.value = true;

      final int newTableId = 1;

      final newGame = await GameService.to.createGame(
        CreateGameDto(tableId: newTableId),
      );

      Get.toNamed('/games/${newGame.gameId}', preventDuplicates: false);
    } catch (e) {
      ErrorService.to.showError('Failed to create game');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void joinGame(Game game) {
    Get.toNamed('/games/${game.gameId}', preventDuplicates: false);
  }
}
