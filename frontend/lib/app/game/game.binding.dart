import 'package:frontend/app/game/game.controller.dart';
import 'package:get/get.dart';

class GamePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GamePageController());
  }
}
