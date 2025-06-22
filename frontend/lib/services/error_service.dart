import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A tiny GetX service that shows a red popup in the
/// **bottom-left corner** of the browser window.
class ErrorService extends GetxService {
  static ErrorService get to => Get.find<ErrorService>();

  void showError(String message) {
    if (Get.isSnackbarOpen) Get.back(); // close the previous one
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.red.shade700,
      snackPosition: SnackPosition.TOP, // bottom edge
      margin: const EdgeInsets.only(left: 20, bottom: 20), // bottom-left
      borderRadius: 8,
      maxWidth: 420, // never full-width
      animationDuration: const Duration(milliseconds: 250),
    );
  }
}
