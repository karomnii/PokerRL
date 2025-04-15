import 'package:frontend/app/login/login.controller.dart';
import 'package:get/get.dart';

class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageController());
  }
}
