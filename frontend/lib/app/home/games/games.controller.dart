import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:get/get.dart';

class GamesPageController extends GetxController {
  final RxList<ActiveGameDto> games = <ActiveGameDto>[].obs;
  final RxBool isLoading = false.obs;
  final errorMessage = RxnString();
  final RxBool sortAscending = true.obs;
  final RxInt sortColumnIndex = 2.obs;
  final RxInt selectedTableId = 1.obs;

  final RxMap<int, int> activePlayersCount = <int, int>{}.obs;

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
      await _loadActivePlayersCounts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadActivePlayersCounts() async {
    for (final game in games) {
      try {
        final count = await GameService.to.getActivePlayersCount(game.gameId!);
        activePlayersCount[game.gameId!] = count;
      } catch (e) {
        activePlayersCount[game.gameId!] = 0;
      }
    }
  }

  Future<void> createGame() async {
    try {
      isLoading.value = true;
      final newGame = await GameService.to.createGame(
        CreateGameDto(tableId: selectedTableId.value),
      );
      print(newGame.gameId);
      Get.toNamed('/games/${newGame.gameId}', preventDuplicates: false);
    } catch (e) {
      ErrorService.to.showError('Failed to create game');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void joinGame(ActiveGameDto game) {
    Get.toNamed('/games/${game.gameId}', preventDuplicates: false);
  }
}
