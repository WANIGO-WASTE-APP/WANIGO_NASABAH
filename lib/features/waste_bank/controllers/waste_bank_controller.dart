import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/models/member_bank_sampah_response.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteBankController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = true.obs;
  final RxList<WasteBankModel> wasteBankList = <WasteBankModel>[].obs;
  final RxBool isRegistered = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWasteBanks();
  }

  Future<void> fetchWasteBanks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final MemberBankSampahResponse? response =
          await _authRepository.getMemberBankSampah();

      if (response != null) {
        isRegistered.value = response.isRegistered;
        wasteBankList.assignAll(response.bankSampah);
      } else {
        errorMessage.value = 'Gagal mengambil data bank sampah';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchWasteBanks();
  }
}
