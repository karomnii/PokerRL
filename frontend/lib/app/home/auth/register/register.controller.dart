import 'package:flutter/cupertino.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:get/get.dart';

class RegisterPageController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final isLoading = false.obs;

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
      Get.snackbar(
        'Invalid data',
        'Please enter a username, a valid email, and a 6-char password.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
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
