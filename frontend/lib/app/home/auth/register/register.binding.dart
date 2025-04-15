import 'package:frontend/app/home/auth/register/register.controller.dart';
import 'package:get/get.dart';

class RegisterPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterPageController());
  }
}
