import 'package:flutter/cupertino.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/error_service.dart';
import 'package:get/get.dart';

class RegisterPageController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final checkedPolicy = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("RegisterPageController initialized");
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.length < 6) {
      ErrorService.to.showError(
        'Invalid data\nPlease enter a username, a valid email, and a 6-char password.',
      );
      return;
    }

    try {
      isLoading.value = true;

      await AuthService.to.register(email, username, password);

      Get.offAllNamed(Routes.home);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
