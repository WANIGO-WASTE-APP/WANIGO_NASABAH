import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteBankDetailController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = true.obs;
  final RxBool isCatalogLoading = false.obs;
  final Rxn<WasteBankModel> wasteBankDetail = Rxn<WasteBankModel>();
  final Rxn<WasteCatalogData> wasteCatalog = Rxn<WasteCatalogData>();
  final RxInt selectedTabIndex = 0.obs;
  final RxString errorMessage = ''.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1 &&
        wasteCatalog.value == null &&
        wasteBankDetail.value != null) {
      fetchWasteCatalog(wasteBankDetail.value!.id, 'kering');
    }
  }

  Future<void> fetchWasteCatalog(int bankSampahId, String kodeKategori) async {
    try {
      isCatalogLoading.value = true;
      final response =
          await _authRepository.getWasteCatalog(bankSampahId, kodeKategori);
      if (response != null && response.data != null) {
        wasteCatalog.value = response.data;
      }
    } catch (e) {
      if (kDebugMode) {
        print("DEBUG - Error fetching waste catalog: $e");
      }
    } finally {
      isCatalogLoading.value = false;
    }
  }

  Future<void> fetchWasteBankDetail(int id,
      {WasteBankModel? initialData}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _authRepository.getNasabahBankSampahDetail(id);
      if (result != null) {
        if (initialData != null) {
          wasteBankDetail.value = result.copyWith(
            isVerified: result.isVerified || initialData.isVerified,
            tonaseCount: result.tonaseCount ?? initialData.tonaseCount,
            nasabahCount: result.nasabahCount ?? initialData.nasabahCount,
            distance: result.distance ?? initialData.distance,
          );
        } else {
          wasteBankDetail.value = result;
        }
      } else {
        errorMessage.value = 'Gagal memuat detail bank sampah';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerAsMember(int bankSampahId) async {
    try {
      isLoading.value = true;
      final success =
          await _authRepository.registerMemberBankSampah(bankSampahId);

      if (success) {
        isLoading.value = false;

        Get.dialog(GlobalModal(
          imagePath: 'assets/icons/success_icon.svg',
          title: 'Berhasil Terdaftar',
          message:
              'Selamat! Anda telah berhasil terdaftar sebagai nasabah bank sampah. Sekarang Anda dapat mulai menyetor sampah',
          primaryButtonText: 'Kembali',
          onPrimaryButtonPressed: () {
            Get.back();
            fetchWasteBankDetail(bankSampahId);
          },
        ));
      } else {
        isLoading.value = false;
        Get.snackbar(
            'Error', 'Gagal mendaftar sebagai anggota. Silakan coba lagi.');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
