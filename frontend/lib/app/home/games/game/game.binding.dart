import 'package:frontend/app/home/games/game/game.controller.dart';
import 'package:frontend/services/game.service.dart';
import 'package:get/get.dart';

class GamePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GamePageController());
    Get.lazyPut(() => GameService());
  }
}
