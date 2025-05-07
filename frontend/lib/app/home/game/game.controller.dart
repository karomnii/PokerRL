import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GamePageController extends GetxController {
  RxList<String?> cardAssets = RxList<String?>.filled(5, null);

  TextEditingController textEditingController = TextEditingController();

  void addCard(String cardStr) {
    for (var i = 0; i < cardAssets.length; i++) {
      if (cardAssets[i] == null) {
        cardAssets[i] = 'assets/cards/$cardStr.png';
        break;
      }
    }
  }
}
