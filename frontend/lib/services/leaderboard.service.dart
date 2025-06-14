import 'package:get/get.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'error_service.dart';

class LeaderboardService extends GetxService {
  static LeaderboardService get to => Get.find<LeaderboardService>();

  final _api = Get.find<Swagger>();

  Future<List<LeaderboardView>> fetchTopPlayers({int count = 10}) async {
    final response = await _api.apiUsersLeaderboardTopGet(count: count);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final error =
          'Failed to load leaderboard: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }
}
