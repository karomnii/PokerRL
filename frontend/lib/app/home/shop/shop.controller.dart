import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// DODANO IMPORT KONTROLERA PROFILU
import 'package:frontend/app/home/profile/profile.controller.dart';

class ShopPageController extends GetxController {
  final RxList<ShopItemDto> cards = RxList<ShopItemDto>();
  final RxList<ShopItemDto> avatars = RxList<ShopItemDto>();
  final RxBool isLoading = true.obs;
  final RxInt currentTab = 0.obs;

  final ScrollController cardsScrollController = ScrollController();
  final ScrollController avatarsScrollController = ScrollController();
  final ScrollController pageScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getShopItems();
  }

  void switchTab(int index) {
    currentTab.value = index;
  }

  void buyAnItem(int itemId) async {
    isLoading.value = true;
    try {
      final res = await ShopService.to.buyAnItem(PurchaseRequestDto(
        itemId: itemId,
        userId: AuthService.to.userId!,
      ));

      if (res.paymentUrl != null) {
        openExternalUrl(res.paymentUrl!);
        // W przypadku zewnętrznej płatności odświeżenie może wymagać powrotu z przeglądarki,
        // ale na razie zostawiamy standardowe flow.
      } else {
        // ZAKUP ZA ŻETONY (SUKCES)
        Get.snackbar(
          'Success',
          res.message ?? 'Item purchased!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // 1. Odświeżamy listę w sklepie (np. żeby zaktualizować stan przycisku kupna)
        getShopItems();

        // 2. --- FIX: ODŚWIEŻAMY PROFIL ---
        // Sprawdzamy, czy kontroler profilu jest w pamięci (czy użytkownik go odwiedził)
        if (Get.isRegistered<ProfilePageController>()) {
          // Wymuszamy pobranie nowych danych (loadData jest publiczne w Twoim nowym kodzie)
          Get.find<ProfilePageController>().loadData();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Purchase failed: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
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
    try {
      final res = await ShopService.to.getShopItems(AuthService.to.userId!);
      cards.clear();
      avatars.clear();
      cards.addAll(res.where((i) => i.itemType == 'CardDeck'));
      avatars.addAll(res.where((i) => i.itemType == 'Avatar'));
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
