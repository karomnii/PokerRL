import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'error_service.dart';

class ProfileService extends GetxService {
  static ProfileService get to => Get.find<ProfileService>();

  static const _tokenKey = 'jwt_token';

  final _api = Get.find<Swagger>();

  final RxnString _token = RxnString();
  String? get token => _token.value;
  bool get isLoggedIn => _token.value != null;

  Future<ProfileService> init() async {
    _token.value = html.window.localStorage[_tokenKey];
    return this;
  }

  Future<UserDto> fetchProfileId(int userId) async {
    final response = await _api.apiUsersProfileUserIdGet(userId: userId);

    if (response.isSuccessful) {
      return response.body!;
    } else {
      final error =
          'Failed to load profile: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }

  Future<UserDto> fetchProfile() async {
    final response = await _api.apiUsersProfileGet();

    if (response.isSuccessful) {
      return response.body!;
    } else {
      final error =
          'Failed to load profile: ${response.error} ${response.body}';
      ErrorService.to.showError(error);
      throw Exception(error);
    }
  }
}
