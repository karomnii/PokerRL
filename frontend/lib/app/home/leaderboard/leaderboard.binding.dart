import 'package:get/get.dart';
import 'package:frontend/app/home/leaderboard/leaderboard.controller.dart';
import 'package:frontend/services/leaderboard.service.dart';

class LeaderboardPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeaderboardPageController());
    Get.lazyPut(() => LeaderboardService());
  }
}
