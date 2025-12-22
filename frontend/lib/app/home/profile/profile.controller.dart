import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/game.service.dart';
import 'package:frontend/services/profile.service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:get/get.dart';
import 'package:frontend/api/swagger.models.swagger.dart';

class ProfilePageController extends GetxController {
  final user = Rxn<UserDto>();
  final errorMessage = RxnString();
  final RxList<ShopItemDto> cards = RxList<ShopItemDto>();
  final RxList<ShopItemDto> avatars = RxList<ShopItemDto>();
  final Rxn<AssetImage> userAvatar = Rxn<AssetImage>();

  final RxInt currentTab = 0.obs;

  final RxString activeDeckName = ''.obs;
  final RxString activeAvatarName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (AuthService.to.userId != null) {
      loadData();
    }
  }

  void loadData() async {
    await loadProfile();
    await getInventoryItems();
    AuthService.to.refreshUser();
  }

  void switchTab(int index) {
    currentTab.value = index;
  }

  void setItem(int itemId) async {
    ShopItemDto? selectedItem;
    bool isDeck = false;

    final foundDecks = cards.where((e) => e.itemId == itemId);
    if (foundDecks.isNotEmpty) {
      selectedItem = foundDecks.first;
      isDeck = true;
    } else {
      final foundAvatars = avatars.where((e) => e.itemId == itemId);
      if (foundAvatars.isNotEmpty) {
        selectedItem = foundAvatars.first;
        isDeck = false;
      }
    }
    if (selectedItem == null || selectedItem.name == null) {
      print("⚠️ Błąd: Nie znaleziono przedmiotu o ID $itemId na listach.");
      return;
    }

    if (isDeck) {
      activeDeckName.value = selectedItem.name!;
    } else {
      activeAvatarName.value = selectedItem.name!;
    }

    try {
      await ShopService.to.setItem(
        AuthService.to.userId!,
        SelectItemDto(itemId: itemId),
      );
      await loadProfile();
    } catch (e) {
      print('Błąd zapisu na serwerze: $e');
      loadProfile();
    }
  }

  Future<void> getInventoryItems() async {
    try {
      final res =
          await ShopService.to.getInventoryItems(AuthService.to.userId!);
      cards.assignAll(res.where((i) => i.itemType == 'CardDeck'));
      avatars.assignAll(res.where((i) => i.itemType == 'Avatar'));
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadProfile() async {
    try {
      final fetched = await ProfileService.to.fetchProfile();
      user.value = fetched;
      if (fetched.deckStyle != null) {
        activeDeckName.value = fetched.deckStyle!;
      }
      if (fetched.avatarImage != null) {
        activeAvatarName.value = fetched.avatarImage!;
      }

      if (fetched.userId != null) {
        try {
          final avatar = await GameService.to.getUserAvatar(fetched.userId!);
          userAvatar.value = avatar;
        } catch (_) {}
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  void addChips() async {
    await ProfileService.to.add1KChips(AuthService.to.userId!);
    Get.snackbar('Success', 'Added 1000 chips!',
        backgroundColor: Colors.green, colorText: Colors.white);
    loadProfile();
  }
}
