import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/leaderboard.service.dart';

class LeaderboardPageController extends GetxController {
  final leaderboard = <LeaderboardView>[].obs;
  final isLoading = false.obs;

  final avatars = <int, AssetImage?>{}.obs;

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
      await _loadAvatars(data);
    } catch (e) {
      ErrorService.to.showError('Failed to load leaderboard');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAvatars(List<LeaderboardView> players) async {
    for (final player in players) {
      final userId = player.userId;
      if (userId != null) {
        try {
          final profile = await LeaderboardService.to.fetchUserProfile(userId);
          final avatarFileName = profile.avatarImage;

          if (avatarFileName != null && avatarFileName.isNotEmpty) {
            avatars[userId] =
                AssetImage('assets/be/avatars/$avatarFileName.png');
          } else {
            avatars[userId] = null;
          }
        } catch (_) {
          avatars[userId] = null;
        }
      }
    }
  }

  AssetImage? getAvatarForUser(int userId) {
    return avatars[userId];
  }
}
