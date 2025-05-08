import 'dart:html' as html;
import 'package:frontend/api/swagger.swagger.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:get/get.dart';
import 'error_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  static const _tokenKey = 'jwt_token';

  final _api = Get.find<Swagger>();

  final RxnString _token = RxnString();
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null;

  Future<AuthService> init() async {
    _token.value = html.window.localStorage[_tokenKey];
    return this;
  }

  Future<void> login(String username, String password) async {
    try {
      final dto = LoginDto(username: username, password: password);
      final jwt = await _api.apiUsersLoginPost(body: dto);
      _saveToken(jwt.body!.token!);
    } catch (e) {
      ErrorService.to.showError('$e');
      rethrow;
    }
  }

  Future<void> register(String email, String username, String password) async {
    try {
      final dto =
          RegisterDto(email: email, username: username, password: password);
      final jwt = await _api.apiUsersRegisterPost(body: dto);
      _saveToken(jwt.body!.token!);
    } catch (e) {
      ErrorService.to.showError('$e');
      rethrow;
    }
  }

  void logout() {
    html.window.localStorage.remove(_tokenKey);
    _token.value = null;
  }

  /* ---------- internals ---------- */

  void _saveToken(String t) {
    html.window.localStorage[_tokenKey] = t;
    _token.value = t;
  }
}
