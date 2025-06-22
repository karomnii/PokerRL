import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPageController extends GetxController {
  final RxList<ShopItemDto> cards = RxList<ShopItemDto>();
  final RxList<ShopItemDto> avatars = RxList<ShopItemDto>();
  final RxBool isLoading = true.obs;

  final ScrollController cardsScrollController = ScrollController();
  final ScrollController avatarsScrollController = ScrollController();
  final ScrollController pageScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getShopItems();
  }

  void buyAnItem(int itemId) async {
    isLoading.value = true;
    final res = await ShopService.to.buyAnItem(PurchaseRequestDto(
      itemId: itemId,
      userId: AuthService.to.userId!,
    ));

    if (res.paymentUrl != null) {
      openExternalUrl(res.paymentUrl!);
      getShopItems();
      return;
    }
    Get.snackbar('', res.message!);
    getShopItems();
    isLoading.value = false;
  }

  void openExternalUrl(String path) {
    final Uri url = Uri.parse(path);

    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  void getShopItems() async {
    isLoading.value = true;
    final res = await ShopService.to.getShopItems(AuthService.to.userId!);
    cards.clear();
    avatars.clear();
    cards.addAll(res.where((i) => i.itemType == 'CardDeck'));
    avatars.addAll(res.where((i) => i.itemType == 'Avatar'));
    isLoading.value = false;
  }
}
