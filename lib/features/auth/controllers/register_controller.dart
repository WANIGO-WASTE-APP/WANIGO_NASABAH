import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

/// Controller untuk halaman registrasi
class RegisterController extends GetxController {
  // Controller untuk input form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Repository
  final AuthRepository _authRepository = AuthRepository();
  
  // Auth Controller - penting untuk mengatur status login
  final AuthController _authController = Get.find<AuthController>();
  
  // State variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Form validation state
  final RxString nameError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  
  // Password visibility state
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  
  // Form filled state untuk tombol aktif/nonaktif
  final RxBool formFilled = false.obs;
  
  // Variabel untuk menandai apakah controller sudah di-dispose
  bool _isDisposed = false;
  
  @override
  void onInit() {
    super.onInit();
    
    // Jika ada email yang diteruskan dari halaman login
    if (Get.arguments != null && Get.arguments is String) {
      emailController.text = Get.arguments as String;
      if (kDebugMode) {
        print("DEBUG - Email yang diterima di register: ${emailController.text}");
      }
    } else {
      if (kDebugMode) {
        print("DEBUG - Tidak ada email yang diteruskan ke register");
      }
    }
    
    // Setup listeners untuk semua field form
    nameController.addListener(_validateFormFilled);
    phoneController.addListener(_validateFormFilled);
    passwordController.addListener(_validateFormFilled);
    confirmPasswordController.addListener(_validateFormFilled);
    
    // Cek status awal form
    _validateFormFilled();
  }
  
  void _validateFormFilled() {
    // Hindari memperbarui state jika controller sudah di-dispose
    if (_isDisposed) return;
    
    // Sederhanakan logika validasi - hanya periksa apakah field diisi dan password cocok
    final allFieldsFilled = 
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
        
    final passwordsMatch = 
        passwordController.text == confirmPasswordController.text;
    
    // Atur status formFilled
    formFilled.value = allFieldsFilled && passwordsMatch;
    
    // Debug prints
    if (kDebugMode) {
      print("DEBUG - All fields filled: $allFieldsFilled");
      print("DEBUG - Password match: $passwordsMatch");
      print("DEBUG - Form valid: ${formFilled.value}");
    }
  }
  
  @override
  void onClose() {
    // Tandai bahwa controller sudah di-dispose
    _isDisposed = true;
    
    // Dispose semua controller
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  /// Validasi form
  bool validateForm() {
    // Hindari validasi jika controller sudah di-dispose
    if (_isDisposed) return false;
    
    bool isValid = true;
    
    // Reset semua error
    nameError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    
    // Validasi nama
    if (nameController.text.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    }
    
    // Validasi nomor telepon
    if (phoneController.text.isEmpty) {
      phoneError.value = 'Nomor telepon tidak boleh kosong';
      isValid = false;
    }
    
    // Validasi password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Kata sandi tidak boleh kosong';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Kata sandi minimal 6 karakter';
      isValid = false;
    }
    
    // Validasi konfirmasi password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Konfirmasi kata sandi tidak boleh kosong';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Konfirmasi kata sandi tidak sama';
      isValid = false;
    }
    
    if (kDebugMode) {
      print("DEBUG - Form validation result: $isValid");
    }
    return isValid;
  }
  
  /// Toggle password visibility
  void togglePasswordVisibility() {
    // Hindari manipulasi state jika controller sudah di-dispose
    if (_isDisposed) return;
    obscurePassword.value = !obscurePassword.value;
  }
  
  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    // Hindari manipulasi state jika controller sudah di-dispose
    if (_isDisposed) return;
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  /// Proses registrasi
  Future<void> register() async {
    // Hindari operasi jika controller sudah di-dispose
    if (_isDisposed) return;
    
    if (kDebugMode) {
      print("DEBUG - Register button clicked");
    }
    
    // Validasi form terlebih dahulu
    if (!validateForm()) {
      if (kDebugMode) {
        print("DEBUG - Form validation failed");
      }
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      if (kDebugMode) {
        print("DEBUG - Calling register API with data: ${nameController.text}, ${emailController.text}, ${phoneController.text}");
      }
      
      // Panggil register
      try {
        final response = await _authRepository.register(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          password: passwordController.text,
        );
        
        // Cek apakah controller masih aktif
        if (_isDisposed) return;
        
        // PERBAIKAN: Update login status pada AuthController
        _authController.isLoggedIn.value = true;
        
        // PERBAIKAN: Set user
        _authController.user.value = response.user;
        
        // PERBAIKAN: Set profileStatus dengan null check yang tepat
        _authController.profileStatus.value = response.profileStatus;
        
        // Logging untuk memastikan status sudah diperbarui
        if (kDebugMode) {
          print("DEBUG - After registration, isLoggedIn: ${_authController.isLoggedIn.value}");
          print("DEBUG - After registration, user: ${_authController.user.value?.name}");
          // PERBAIKAN: Tambahkan null check yang benar
          print("DEBUG - After registration, profileStatus: ${_authController.profileStatus.value?.nextStep ?? 'null'}");
        }
        
        // PERBAIKAN: Tunggu sedikit waktu agar status login disimpan
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Navigasi ke insight intro dengan nama user
        Get.offAllNamed(Routes.insight, arguments: nameController.text.trim());
        
      } catch (e) {
        // Cek apakah controller masih aktif
        if (_isDisposed) return;
        
        // Error handling yang lebih spesifik
        String errorMsg = e.toString().replaceAll("Exception: ", "");
        
        // Cek untuk berbagai jenis error
        if (errorMsg.contains("email has already been taken") || 
            errorMsg.contains("email sudah terdaftar")) {
          errorMessage.value = "Email sudah terdaftar, silakan gunakan email lain";
        } else if (errorMsg.contains("invalid") || errorMsg.contains("tidak valid")) {
          errorMessage.value = "Data yang dimasukkan tidak valid, silakan periksa kembali";
        } else if (errorMsg.contains("connection") || errorMsg.contains("lookup")) {
          errorMessage.value = "Gagal terhubung ke server. Silakan periksa koneksi internet Anda.";
        } else if (errorMsg.contains("Gagal mengirim data") && errorMsg.contains("bad response")) {
          // Jika masih ada bad response, berikan pesan yang lebih user-friendly
          errorMessage.value = "Terjadi kesalahan pada server. Silakan coba lagi nanti.";
        } else {
          errorMessage.value = errorMsg;
        }
        
        if (kDebugMode) {
          print("DEBUG - Registration error: $errorMsg");
        }
        
        Get.snackbar(
          'Registrasi Gagal',
          errorMessage.value,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      // Hindari manipulasi state jika controller sudah di-dispose
      if (_isDisposed) return;
      
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print("DEBUG - Exception during registration: $e");
      }
      
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      // Hindari manipulasi state jika controller sudah di-dispose
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }
}