import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/profile.service.dart';
import 'package:get/get.dart';
import 'package:frontend/api/swagger.models.swagger.dart';

class ProfilePageController extends GetxController {
  final user = Rxn<UserDto>();
  final errorMessage = RxnString();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      user.value = await ProfileService.to.fetchProfile();
      errorMessage.value = null;
    } catch (e) {
      ErrorService.to.showError('Failed to load profile');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
