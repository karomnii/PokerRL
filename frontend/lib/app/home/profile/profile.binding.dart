import 'package:frontend/app/home/profile/profile.controller.dart';
import 'package:frontend/services/profile.service.dart';
import 'package:get/get.dart';

class ProfilePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfilePageController());
    Get.lazyPut(() => ProfileService());
  }
}
