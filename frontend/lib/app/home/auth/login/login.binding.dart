import 'package:frontend/app/home/auth/login/login.controller.dart';
import 'package:get/get.dart';

class LoginPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageController());
  }
}
