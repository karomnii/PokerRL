import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:get/get.dart';

class ShopPageController extends GetxController {
  final RxList<ShopItemDto> cards = RxList<ShopItemDto>();
  final RxList<ShopItemDto> avatars = RxList<ShopItemDto>();
  final RxBool isLoading = true.obs;
  final Rxn<AssetImage> userAvatar = Rxn<AssetImage>();

  final ScrollController cardsScrollController = ScrollController();
  final ScrollController avatarsScrollController = ScrollController();
  final ScrollController pageScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getShopItems();
  }

  void getShopItems() async {
    isLoading.value = true;
    final res = await ShopService.to.getShopItems(AuthService.to.userId!);

    cards.addAll(res.where((i) => i.itemType == 'CardDeck'));
    avatars.addAll(res.where((i) => i.itemType == 'Avatar'));
    isLoading.value = false;
  }
}
