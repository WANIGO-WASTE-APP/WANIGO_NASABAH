import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/data/models/auth_models.dart';

class AccountSettingsController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final AuthRepository _authRepository = AuthRepository();

  // Form Controllers
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  // State variables
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize controllers with current user data
    final user = _authController.user.value;
    nameController = TextEditingController(text: user?.name ?? '');
    phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Update profile method
  Future<void> updateProfile() async {
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama dan Nomor Telepon tidak boleh kosong',
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authRepository.updateProfile(
        name: name,
        phone: phone,
      );
      
      if (response['status'] == 'success') {
        // Update user in AuthController state
        final updatedUser = await _authRepository.getUser();
        if (updatedUser != null) {
          _authController.user.value = updatedUser;
        }

        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Gagal',
          response['message'],
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat memperbarui profil',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Change profile photo method
  void changeProfilePhoto() {
    // Logic to pick image from gallery or camera
  }
}
