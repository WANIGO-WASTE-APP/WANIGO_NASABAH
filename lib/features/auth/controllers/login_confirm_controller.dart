import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

/// Controller untuk halaman konfirmasi login (input password)
class LoginConfirmController extends GetxController {
  // Email dari halaman sebelumnya
  late String email;
  
  // Controller untuk input password
  final TextEditingController passwordController = TextEditingController();
  
  // State variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool obscurePassword = true.obs;
  
  // Reference ke main auth controller dan repository
  final AuthController _authController = Get.find<AuthController>();
  final AuthRepository _authRepository = AuthRepository();
  
  // Flag untuk menandai controller di-dispose
  bool _isDisposed = false;
  
  // Throttle untuk login request
  DateTime? _lastLoginTime;
  static const Duration _loginThrottleTime = Duration(milliseconds: 1000);
  
  @override
  void onInit() {
    super.onInit();
    
    // Ambil email dari arguments
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        email = Get.arguments as String;
        if (kDebugMode) {
          print("DEBUG - Email received in login confirm: $email");
        }
      } else {
        // Coba ekstrak dari Map jika arguments adalah Map
        try {
          Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
          if (args.containsKey('email')) {
            email = args['email'];
            if (kDebugMode) {
              print("DEBUG - Email extracted from map in login confirm: $email");
            }
          } else {
            throw Exception("No email key in arguments map");
          }
        } catch (e) {
          if (kDebugMode) {
            print("DEBUG - Failed to extract email from arguments: $e");
          }
          // Fallback ke empty string
          email = '';
          
          // Kembali ke halaman login jika tidak ada email
          Get.offAllNamed(Routes.login);
        }
      }
    } else {
      // Jika tidak ada email, kembali ke halaman login
      if (kDebugMode) {
        print("DEBUG - No email received, returning to login");
      }
      email = '';
      Get.offAllNamed(Routes.login);
    }
  }
  
  @override
  void onClose() {
    _isDisposed = true; // Tandai controller di-dispose
    passwordController.dispose();
    super.onClose();
  }
  
  /// Toggle password visibility
  void togglePasswordVisibility() {
    if (_isDisposed) return; // Cek apakah sudah di-dispose
    obscurePassword.value = !obscurePassword.value;
  }
  
  /// Validasi input password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    return null;
  }
  
  /// Proses login
  Future<void> login() async {
    // Cek apakah controller sudah di-dispose
    if (_isDisposed) {
      if (kDebugMode) {
        print("DEBUG - Controller already disposed, cancelling login");
      }
      return;
    }
    
    // Hindari request beruntun terlalu cepat
    if (_lastLoginTime != null) {
      final difference = DateTime.now().difference(_lastLoginTime!);
      if (difference < _loginThrottleTime) {
        if (kDebugMode) {
          print("DEBUG - Throttling login request. Time since last request: ${difference.inMilliseconds}ms");
        }
        return;
      }
    }
    _lastLoginTime = DateTime.now();
    
    // Validasi password
    final passwordValidation = validatePassword(passwordController.text);
    if (passwordValidation != null) {
      errorMessage.value = passwordValidation;
      
      // Cek apakah controller masih aktif
      if (!_isDisposed) {
        Get.snackbar(
          'Perhatian',
          errorMessage.value,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
      
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      if (kDebugMode) {
        print("DEBUG - Attempting login with email: $email and password length: ${passwordController.text.length}");
      }
      
      try {
        // Panggil API login direct dengan AuthRepository
        final response = await _authRepository.login(
          email,
          passwordController.text,
        ).timeout(const Duration(seconds: 30), onTimeout: () {
          throw Exception('Timeout: Server tidak merespon dalam waktu yang ditentukan');
        });
        
        // Cek apakah controller masih aktif
        if (_isDisposed) return;
        
        // Login berhasil, update user dan profileStatus
        _authController.user.value = response.user;
        _authController.profileStatus.value = response.profileStatus;
        _authController.isLoggedIn.value = true;
        
        // Simpan token untuk request selanjutnya
        if (kDebugMode) {
          print("DEBUG - Login successful, token received and profile status updated");
          print("DEBUG - Profile status: isCompleted=${response.profileStatus.isCompleted}, nextStep=${response.profileStatus.nextStep}");
        }
        
        // Tambahkan delay untuk memastikan status login tersimpan
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Debug informasi - cek jika jenis_sampah_dikelola sudah diisi
        if (response.user.nasabah != null) {
          if (kDebugMode) {
            print("DEBUG - Nasabah profile found");
            print("DEBUG - jenis_sampah_dikelola: ${response.user.nasabah!.jenisSampahDikelola}");
            print("DEBUG - profile_completed_at: ${response.user.nasabah!.profileCompletedAt}");
          }
          
          // Cek field jenis_sampah_dikelola terlebih dahulu sebagai indikator profil lengkap
          if (response.user.nasabah!.jenisSampahDikelola != null && 
              response.user.nasabah!.jenisSampahDikelola!.isNotEmpty) {
            
            if (kDebugMode) {
              print("DEBUG - Profile complete based on jenis_sampah_dikelola, navigating to home");
            }
            Get.offAllNamed(Routes.home);
            return;
          }
        }
        
        // Navigasi berdasarkan status profil
        if (response.profileStatus.isCompleted) {
          // Profil sudah lengkap, arahkan ke home
          if (kDebugMode) {
            print("DEBUG - Profile complete, navigating to home");
          }
          Get.offAllNamed(Routes.home);
        } else {
          // Profil belum lengkap
          String nextStep = response.profileStatus.nextStep;
          
          // Jika next step tidak ada, cek completion percentage
          if (nextStep.isEmpty && response.profileStatus.completionPercentage == 0) {
            // User baru, arahkan ke insight intro
            if (kDebugMode) {
              print("DEBUG - Profile incomplete, navigating to insight intro");
            }
            Get.offAllNamed(Routes.insight, arguments: response.user.name);
          } else {
            // Arahkan ke step yang sesuai
            switch (nextStep) {
              case 'step1':
                if (kDebugMode) {
                  print("DEBUG - Navigating to profile step 1");
                }
                Get.offAllNamed(Routes.profileStep1);
                break;
              case 'step2':
                if (kDebugMode) {
                  print("DEBUG - Navigating to profile step 2");
                }
                Get.offAllNamed(Routes.profileStep2);
                break;
              case 'step3':
                if (kDebugMode) {
                  print("DEBUG - Navigating to profile step 3");
                }
                Get.offAllNamed(Routes.profileStep3);
                break;
              default:
                if (kDebugMode) {
                  print("DEBUG - Unknown profile step, navigating to insight intro");
                }
                Get.offAllNamed(Routes.insight, arguments: response.user.name);
            }
          }
        }
      } catch (e) {
        // Cek apakah controller masih aktif
        if (_isDisposed) return;
        
        // Error handling yang lebih user-friendly
        if (kDebugMode) {
          print("DEBUG - Login error from API: $e");
        }
        
        // Cek jika masalah koneksi
        if (e.toString().contains('koneksi') || 
            e.toString().contains('network') || 
            e.toString().contains('Failed host lookup') ||
            e.toString().contains('Timeout') ||
            e.toString().contains('timeout')) {
          
          errorMessage.value = "Gagal terhubung ke server. Silahkan periksa koneksi internet Anda.";
          Get.snackbar(
            'Koneksi Gagal',
            errorMessage.value,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 5),
          );
          return;
        }
        
        String errorMsg = e.toString().replaceAll("Exception: ", "");
        
        // Cek pesan error dan berikan pesan yang lebih user-friendly
        if (errorMsg.contains("Email atau kata sandi salah") || 
            errorMsg.contains("invalid credentials")) {
          errorMessage.value = "Email atau kata sandi salah";
        } else if (errorMsg.contains("connection") || errorMsg.contains("lookup")) {
          errorMessage.value = "Gagal terhubung ke server. Silakan periksa koneksi internet Anda.";
        } else {
          errorMessage.value = errorMsg;
        }
        
        // Tampilkan error dalam snackbar
        Get.snackbar(
          'Gagal Login',
          errorMessage.value,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      // Cek apakah controller masih aktif
      if (_isDisposed) return;
      
      // Handling error umum
      errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
      if (kDebugMode) {
        print("DEBUG - General login exception: ${errorMessage.value}");
      }
      
      // Tampilkan error dalam snackbar
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      // Update loading state hanya jika controller masih aktif
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }
  
  /// Navigasi ke halaman lupa password
  void goToForgotPassword() {
    // Cek apakah controller sudah di-dispose
    if (_isDisposed) return;
    Get.toNamed(Routes.forgotPassword, arguments: email);
  }
}