import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteBankDetailController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = true.obs;
  final Rxn<WasteBankModel> wasteBankDetail = Rxn<WasteBankModel>();
  final RxInt selectedTabIndex = 0.obs;
  final RxString errorMessage = ''.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> fetchWasteBankDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _authRepository.getNasabahBankSampahDetail(id);
      if (result != null) {
        wasteBankDetail.value = result;
      } else {
        errorMessage.value = 'Gagal memuat detail bank sampah';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
