import 'package:frontend/app/home/games/games.controller.dart';
import 'package:frontend/services/game.service.dart';
import 'package:get/get.dart';

class GamesPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GamesPageController());
    Get.lazyPut(() => GameService());
  }
}
