import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/error_service.dart';

class AuthPageController extends GetxController {
  final String googleClientId =
      '533287616724-te0nubq86i5lflffeb89na991ljfiq47.apps.googleusercontent.com';

  late GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();

    _googleSignIn = GoogleSignIn(
      clientId: googleClientId,
      scopes: ['email', 'profile', 'openid'],
    );

    // TODO: MICHAL NAPRAW
    // if (kIsWeb) {
    //   html.window.addEventListener('googleSignIn', (event) {
    //     final customEvent = event as html.CustomEvent;
    //     final idToken = customEvent.detail as String;
    //     loginWithGoogleIdToken(idToken);
    //   });
    // }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final account = await _googleSignIn.signInSilently();
        if (account != null) {
          final auth = await account.authentication;
          final idToken = auth.idToken;
          if (idToken != null && idToken.isNotEmpty) {
            await loginWithGoogleIdToken(idToken);
            return;
          }
        }
        ErrorService.to
            .showError('Kliknij przycisk Google Sign-In, aby się zalogować.');
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return;
        }
        final googleAuth = await googleUser.authentication;
        final idToken = googleAuth.idToken;
        if (idToken != null && idToken.isNotEmpty) {
          await loginWithGoogleIdToken(idToken);
        } else {
          ErrorService.to
              .showError('Google login failed: No ID token received');
        }
      }
    } catch (e) {
      ErrorService.to.showError('Google login failed: $e');
    }
  }

  Future<void> loginWithGoogleIdToken(String idToken) async {
    print("Google ID Token: $idToken");
    try {
      await AuthService.to.loginWithSocial(provider: 'google', token: idToken);
      Get.offAllNamed('/home');
    } catch (e) {
      ErrorService.to.showError('Backend login failed: $e');
    }
  }
}
