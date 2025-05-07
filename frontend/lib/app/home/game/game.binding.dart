import 'package:frontend/app/home/game/game.controller.dart';
import 'package:get/get.dart';

class GamePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GamePageController());
  }
}
