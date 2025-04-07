import 'package:frontend/app/shop/shop.controller.dart';
import 'package:get/get.dart';

class ShopPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShopPageController());
  }
}
