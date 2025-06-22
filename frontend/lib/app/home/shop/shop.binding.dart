import 'package:frontend/app/home/shop/shop.controller.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:get/get.dart';

class ShopPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopPageController());
    Get.lazyPut(() => ShopService());
  }
}
