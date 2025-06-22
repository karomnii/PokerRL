import 'package:get/get.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'error_service.dart';

class LeaderboardService extends GetxService {
  static LeaderboardService get to => Get.find<LeaderboardService>();

  final _api = Get.find<Swagger>();

  Future<List<LeaderboardView>> fetchTopPlayers({int count = 10}) async {
    final response = await _api.apiUsersLeaderboardTopGet(count: 20);

    if (response.isSuccessful && response.body != null) {
      final botIds = {1, 2, 3, 4, 5, 6, 7, 8, 9};
      final filtered = response.body!
          .where((player) => !botIds.contains(player.userId))
          .take(count)
          .toList();

      return filtered;
    } else {
      final error =
          'Failed to load leaderboard: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<UserDto> fetchUserProfile(int userId) async {
    final response = await _api.apiUsersProfileUserIdGet(userId: userId);

    if (response.isSuccessful && response.body != null) {
      return response.body!;
    } else {
      final error =
          'Failed to load user profile: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }
}
