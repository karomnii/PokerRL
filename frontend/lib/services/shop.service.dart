import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:get/get.dart';
import 'error_service.dart';
import 'package:flutter/services.dart' as svc;

class ShopService extends GetxService {
  static ShopService get to => Get.find<ShopService>();
  static const _tokenKey = 'jwt_token';

  final _api = Get.find<Swagger>();

  final RxnString _token = RxnString();
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null;

  Future<ShopService> init() async {
    _token.value = html.window.localStorage[_tokenKey];
    return this;
  }

  Map<String, dynamic>? _assetManifest;

  Future<void> _ensureManifestLoaded() async {
    if (_assetManifest != null) return; // już mamy
    final jsonStr = await svc.rootBundle.loadString('AssetManifest.json');
    _assetManifest = json.decode(jsonStr) as Map<String, dynamic>;
  }

  Future<List<ShopItemDto>> getShopItems(int userId) async {
    final response = await _api.apiUsersShopUserIdGet(userId: userId);

    if (response.isSuccessful) {
      return response.body ?? [];
    } else {
      final error =
          'Failed to load shop items: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<List<ShopItemDto>> getInventoryItems(int userId) async {
    final response = await _api.apiUsersInventoryUserIdGet(userId: userId);

    if (response.isSuccessful) {
      return response.body ?? [];
    } else {
      final error =
          'Failed to load inventory items: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<void> setItem(int userId, SelectItemDto body) async {
    final response =
        await _api.apiUsersSetItemUserIdPost(userId: userId, body: body);

    if (!response.isSuccessful) {
      final error = 'Failed to set item: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<PurchaseResponseDto> buyAnItem(PurchaseRequestDto body) async {
    final response =
        await _api.apiPaymentsCreateCheckoutSessionPost(body: body);

    if (response.isSuccessful) {
      return response.body!;
    } else {
      final error =
          'Failed to load inventory items: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<List<AssetImage>> imageList(String name, String type) async {
    if (type == 'Avatar') {
      return [AssetImage('assets/be/avatars/$name.png')];
    }

    await _ensureManifestLoaded();
    String path = name
        .split(' ')
        .map((w) => w.toLowerCase())
        .toList()
        .sublist(0, name.split(' ').length - 1)
        .join('-')
        .trim();

    final dir = 'assets/be/cards/$path/';
    final matchingKeys = _assetManifest!.keys
        .where((p) => p.startsWith(dir) && p.endsWith('.png'))
        .toList();
    final images = _assetManifest!.keys
        .where((p) => p.startsWith(dir) && p.endsWith('.png'))
        .map((p) {
      final ai = AssetImage(p);
      return ai;
    }).toList();
    // print(_assetManifest!.keys.where((p) => p.contains('sepia')));
    if (images.isEmpty) {
      throw StateError('Brak obrazków w $dir - sprawdź pubspec.yaml');
    }
    return images;
  }
}

// class ShopItemDto {
//   const ShopItemDto({
//     this.itemId,
//     this.name,
//     this.description,
//     this.price,
//     this.itemType,
//     this.currency,
//   });
