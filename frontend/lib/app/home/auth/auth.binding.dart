import 'package:get/get.dart';
import 'package:frontend/app/home/auth/login/login.controller.dart';
import 'package:frontend/app/home/auth/auth.controller.dart';

class AuthPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthPageController());
  }
}
