import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteBankDetailController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = true.obs;
  final Rxn<WasteBankModel> wasteBankDetail = Rxn<WasteBankModel>();
  final RxInt selectedTabIndex = 0.obs;
  final RxString errorMessage = ''.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
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
            // Refresh detail to update UI ONLY after clicking "Kembali"
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
