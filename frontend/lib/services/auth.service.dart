import 'dart:convert';
import 'dart:html' as html;
import 'package:frontend/api/swagger.swagger.dart';
import 'package:get/get.dart';
import 'error_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  static const _tokenKey = 'jwt_token';

  final _api = Get.find<Swagger>();

  final RxnString _token = RxnString();
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null && _token.value != '';

  static const _userKey = 'user_info'; // <-- NEW

  final Rxn<UserDto> _user = Rxn<UserDto>(); // <-- NEW

  UserDto? get user => _user.value;
  int? get userId => _user.value?.userId; // convenience

  Future<AuthService> init() async {
    _token.value = html.window.localStorage[_tokenKey];

    final rawUser = html.window.localStorage[_userKey];
    if (rawUser != null) {
      _user.value =
          UserDto.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
    }

    return this;
  }

  Future<void> login(String username, String password) async {
    try {
      final dto = LoginDto(username: username, password: password);
      final jwt = await _api.apiUsersLoginPost(body: dto);
      if (jwt.error != null) {
        final decoded = jsonDecode(jwt.error as String);
        final title = decoded['title'] ?? 'Error';

        final errorsMap = decoded['errors'];
        String errorMessages = '';

        if (errorsMap is Map<String, dynamic>) {
          final messages = <String>[];
          errorsMap.forEach((key, value) {
            if (value is List) {
              messages.addAll(value.map((e) => e.toString()));
            }
          });
          errorMessages = messages.join(', ');
        }

        final message =
            errorMessages.isNotEmpty ? '$title: $errorMessages' : title;

        ErrorService.to.showError(message);
        throw '';
      }
      _saveToken(jwt.body!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String username, String password) async {
    try {
      final dto =
          RegisterDto(email: email, username: username, password: password);
      final jwt = await _api.apiUsersRegisterPost(body: dto);
      if (jwt.error != null) {
        final decoded = jsonDecode(jwt.error as String);
        final title = decoded['title'] ?? 'Error';

        final errorsMap = decoded['errors'];
        String errorMessages = '';

        if (errorsMap is Map<String, dynamic>) {
          final messages = <String>[];
          errorsMap.forEach((key, value) {
            if (value is List) {
              messages.addAll(value.map((e) => e.toString()));
            }
          });
          errorMessages = messages.join(', ');
        }

        final message =
            errorMessages.isNotEmpty ? '$title: $errorMessages' : title;

        ErrorService.to.showError(message);
        throw '';
      }
      _saveToken(jwt.body!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithSocial(
      {required String provider, required String token}) async {
    try {
      final socialDto = SocialLoginDto(provider: provider, token: token);
      final response = await _api.apiUsersSocialLoginPost(body: socialDto);
      if (response.error != null) {
        _handleError(response.error as String);
      }
      _saveToken(response.body!);
    } catch (e) {
      ErrorService.to.showError('Social login failed: $e');
      rethrow;
    }
  }

  void logout() {
    html.window.localStorage.remove(_tokenKey);
    _token.value = null;
  }

  void _handleError(String error) {
    final decoded = jsonDecode(error);
    final title = decoded['title'] ?? 'Error';

    final errorsMap = decoded['errors'];
    String errorMessages = '';

    if (errorsMap is Map<String, dynamic>) {
      final messages = <String>[];
      errorsMap.forEach((key, value) {
        if (value is List) {
          messages.addAll(value.map((e) => e.toString()));
        }
      });
      errorMessages = messages.join(', ');
    }

    final message = errorMessages.isNotEmpty ? '$title: $errorMessages' : title;

    ErrorService.to.showError(message);
    throw '';
  }

  Future<void> refreshUser() async {
    try {
      final response = await _api.apiUsersProfileGet();

      if (response.isSuccessful && response.body != null) {
        _user.value = response.body;
        html.window.localStorage[_userKey] = jsonEncode(response.body);
      } else {
        ErrorService.to.showError('Nie udało się pobrać danych użytkownika.');
      }
    } catch (e) {
      ErrorService.to.showError('Błąd podczas odświeżania użytkownika: $e');
    }
  }

  void _saveToken(UserDto user) {
    html.window.localStorage[_tokenKey] = user.token!;
    _token.value = user.token!;
    html.window.localStorage[_userKey] = jsonEncode(user);
    _user.value = user;
  }
}
