import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/error_service.dart';

class AuthPageController extends GetxController {
  final checkedPolicy = false.obs;

  late GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn(
      serverClientId:
          '223466103850-5vqlkbbc8oefpl2sh3oumjmbtgaiot72.apps.googleusercontent.com',
      scopes: ['email', 'profile', 'openid'],
    );
  }

  Future<void> loginWithGoogle() async {
    if (!checkedPolicy.value) return;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      print(
          "Otrzymany ID Token: ${idToken != null ? 'TAK (długość: ${idToken.length})' : 'NIE (null)'}");

      if (idToken != null && idToken.isNotEmpty) {
        await loginWithBackend(idToken);
      } else {
        ErrorService.to.showError(
            'Google login failed: No ID token received (Check Web Client ID)');
      }
    } catch (e) {
      print("Google Sign In Error: $e");
      ErrorService.to.showError('Google login failed: $e');
    }
  }

  Future<void> loginWithBackend(String idToken) async {
    print("Sending Google ID Token to Backend...");
    try {
      await AuthService.to.loginWithSocial(provider: 'google', token: idToken);
      Get.offAllNamed('/home');
    } catch (e) {
      ErrorService.to.showError('Backend login failed: $e');
    }
  }
}
