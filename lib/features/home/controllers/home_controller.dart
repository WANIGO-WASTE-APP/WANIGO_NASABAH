import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/auth_models.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  // Repository
  final AuthRepository _authRepository = AuthRepository();
  final AuthController _authController = Get.find<AuthController>();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Derive user from AuthController for data consistency
  UserModel? get user => _authController.user.value;

  // User points (hardcoded for now)
  int get userPoints => 0;

  // Tabungan data
  final RxDouble saldoTabungan = 24000.00.obs;
  final RxDouble beratSampah = 12.0.obs;

  // Flag untuk menandai controller di-dispose
  bool _isDisposed = false;

  // User name derived from user object
  String get userName => user?.name ?? 'Nasabah';

  // Address and Bank Name state
  final RxString address = ''.obs;
  final RxString bankSampahName = ''.obs;

  // Bottom Navigation Index
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) print("DEBUG - HomeController.onInit called");

    // Handle navigation arguments for tab selection
    if (Get.arguments is Map && Get.arguments.containsKey('index')) {
      currentIndex.value = Get.arguments['index'];
    } else if (Get.arguments is int) {
      currentIndex.value = Get.arguments;
    }

    _loadInitialData();
  }

  /// Public method to manually trigger a data refresh
  Future<void> refreshHomeData() async {
    await _loadInitialData();
  }

  @override
  void onClose() {
    if (kDebugMode) print("DEBUG - HomeController.onClose called (Disposing)");
    _isDisposed = true;
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    if (_isDisposed) return;

    // Prevent multiple parallel loads
    if (isLoading.value) {
      if (kDebugMode)
        print("DEBUG - HomeController: Load already in progress, skipping...");
      return;
    }

    if (kDebugMode)
      print("DEBUG - HomeController._loadInitialData starting...");
    isLoading.value = true;

    try {
      // Sync local user if null
      if (user == null) {
        if (kDebugMode)
          print("DEBUG - HomeController: User is null, fetching from repo");
        final userData = await _authRepository.getUser();
        if (userData != null && !_isDisposed) {
          _authController.user.value = userData;
        }
      }

      // Fetch fresh profile data
      try {
        if (kDebugMode)
          print("DEBUG - HomeController: Fetching Nasabah Profile");
        final nasabahProfile = await _authRepository.getNasabahProfile();
        if (!_isDisposed) {
          _authController.user.value = nasabahProfile;
        }
      } catch (e) {
        if (kDebugMode) print("DEBUG - Error fetching nasabah profile: $e");
      }

      // Fetch member bank data
      try {
        if (kDebugMode)
          print("DEBUG - HomeController: Fetching Member Bank Sampah");
        final memberBankSampah = await _authRepository.getMemberBankSampah();

        if (_isDisposed) {
          if (kDebugMode)
            print(
                "DEBUG - HomeController: Member Bank response received but controller was ALREADY DISPOSED");
          return;
        }

        if (memberBankSampah != null) {
          if (kDebugMode)
            print(
                "DEBUG - HomeController: Received ${memberBankSampah.bankSampah.length} member banks");

          if (memberBankSampah.bankSampah.isNotEmpty) {
            // Urutkan berdasarkan ID (terkecil ke terbesar) dan ambil yang pertama
            final sortedBanks =
                List<WasteBankModel>.from(memberBankSampah.bankSampah);
            sortedBanks.sort((a, b) => a.id.compareTo(b.id));

            final targetBank = sortedBanks.first;
            address.value = targetBank.address;
            bankSampahName.value = targetBank.name;

            if (kDebugMode) {
              print(
                  "DEBUG - HomeController: Selected Bank (ID MIN): ${targetBank.id} - ${targetBank.name}");
            }
          } else {
            if (kDebugMode)
              print(
                  "DEBUG - HomeController: Member Bank list is EMPTY after parsing");
          }
        } else {
          if (kDebugMode)
            print(
                "DEBUG - HomeController: Member Bank Response is ACTUALLY NULL from Repository");
        }
      } catch (e) {
        if (kDebugMode) print("DEBUG - Error fetching member bank: $e");
      }
    } catch (e) {
      if (!_isDisposed) errorMessage.value = e.toString();
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        if (kDebugMode)
          print(
              "DEBUG - HomeController._loadInitialData finished successfully");
      } else {
        if (kDebugMode)
          print(
              "DEBUG - HomeController._loadInitialData finished but controller was DISPOSED");
      }
    }
  }

  void onBottomNavTapped(int index) {
    if (_isDisposed) return;

    // Optional: Sync currentIndex for legacy support or other observers
    currentIndex.value = index;

    switch (index) {
      case 0:
        if (Get.currentRoute != Routes.home) {
          Get.until((route) => route.settings.name == Routes.home);
        }
        break;
      case 1:
        if (Get.currentRoute != Routes.setoranHistory) {
          Get.toNamed(Routes.setoranHistory);
        }
        break;
      case 2:
        if (Get.currentRoute != Routes.depositSelectBank) {
          Get.toNamed(Routes.depositSelectBank);
        }
        break;
      case 3:
        // Future: Pesan screen
        break;
      case 4:
        if (Get.currentRoute != Routes.profile) {
          Get.toNamed(Routes.profile);
        }
        break;
    }
  }

  void goToProfile() {
    if (_isDisposed) return;
    Get.toNamed(Routes.profile);
  }

  Future<void> logout() async {
    if (_isDisposed) return;
    isLoading.value = true;
    try {
      await _authController.logout();
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }
}
