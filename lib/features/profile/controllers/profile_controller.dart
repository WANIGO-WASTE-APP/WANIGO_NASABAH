import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // State variables
  final RxBool isLoading = false.obs;

  // Derive user info from AuthController
  String get userName => _authController.user.value?.name ?? 'Nasabah WANIGO!';
  String get userRole => 'Pengguna WANIGO!';
  String? get profilePhotoUrl => _authController.user.value?.profilePhotoUrl;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("DEBUG - ProfileController initialized");
    }
  }

  /// Logout from the application
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authController.logout();
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigation methods
  void goToAccountSettings() {
    Get.toNamed(Routes.editProfile);
  }

  void goToAppSettings() {
    if (kDebugMode) print("DEBUG - Navigating to App Settings");
  }

  void goToHelpCenter() {
    if (kDebugMode) print("DEBUG - Navigating to Help Center");
  }

  void back() {
    Get.back();
  }
}
