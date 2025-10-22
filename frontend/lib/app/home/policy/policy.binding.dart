import 'package:frontend/app/home/policy/policy.controller.dart';
import 'package:get/get.dart';

class PolicyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PolicyPageController());
  }
}
