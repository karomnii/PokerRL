import 'package:get/get.dart';
import 'package:frontend/services/leaderboard.service.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/api/swagger.models.swagger.dart';

class LeaderboardPageController extends GetxController {
  final leaderboard = <LeaderboardView>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard({int count = 10}) async {
    isLoading.value = true;
    try {
      final data = await LeaderboardService.to.fetchTopPlayers(count: count);
      leaderboard.assignAll(data);
    } catch (e) {
      ErrorService.to.showError('Failed to load leaderboard');
    } finally {
      isLoading.value = false;
    }
  }
}
