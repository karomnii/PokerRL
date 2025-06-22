import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/error_service.dart';
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

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    getInventoryItems();
    AuthService.to.refreshUser();

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (_) {
      loadProfile();
      getInventoryItems();
      AuthService.to.refreshUser();
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel(); // zatrzymanie timera przy dispose
    super.onClose();
  }

  void setItem(int itemId) async {
    ShopService.to.setItem(
      AuthService.to.userId!,
      SelectItemDto(itemId: itemId),
    );
  }

  void getInventoryItems() async {
    final res = await ShopService.to.getInventoryItems(AuthService.to.userId!);
    cards.assignAll(res.where((i) => i.itemType == 'CardDeck'));
    avatars.assignAll(res.where((i) => i.itemType == 'Avatar'));
  }

  Future<void> loadProfile() async {
    try {
      final fetched = await ProfileService.to.fetchProfile();

      if (jsonEncode(fetched) != jsonEncode(user.value)) {
        user.value = fetched;

        // odśwież avatar tylko jeśli faktycznie się zmienił
        final id = fetched.userId;
        if (id != null) {
          try {
            final avatar = await GameService.to.getUserAvatar(id);
            userAvatar.value = avatar;
          } catch (_) {
            // zostaw stary avatar jeśli nie udało się pobrać
          }
        }
      }

      errorMessage.value = null;
    } catch (e) {
      ErrorService.to.showError('Failed to load profile');
      errorMessage.value = e.toString();
    }
  }

  void addChips() async {
    ProfileService.to.add1KChips(AuthService.to.userId!);
    Get.snackbar('Success', 'Enjoy your chips!');
  }
}
