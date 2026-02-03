import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_history_model.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class DepositHistoryController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxList<WasteDepositHistoryModel> historyItems =
      <WasteDepositHistoryModel>[].obs;
  final RxList<WasteBankModel> memberBankList = <WasteBankModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxInt subTabIndex = 0.obs;
  final RxString errorMessage = ''.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1) {
      fetchOngoingSetoran();
    } else {
      fetchMemberBanks(); // Default fetch for "Selesai"
    }
  }

  Future<void> fetchMemberBanks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final status = subTabIndex.value == 0 ? 'selesai' : 'dibatalkan';
      final response = await _repository.getDepositHistory(status);

      if (response != null && response.data != null) {
        historyItems.assignAll(response.data!.data);
      } else {
        historyItems.clear();
      }

      // Also keep original fetchMemberBanks logic if needed for other purposes,
      // but here historyItems is what's displayed.
      final memberResponse = await _repository.getMemberBankSampah();
      if (memberResponse != null && memberResponse.bankSampah.isNotEmpty) {
        memberBankList.assignAll(memberResponse.bankSampah);
      } else {
        memberBankList.clear();
      }
    } catch (e) {
      historyItems.clear();
      memberBankList.clear();
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOngoingSetoran() async {
    try {
      isLoading.value = true;
      final response = await _repository.getOngoingSetoran();
      if (response != null && response.success && response.data != null) {
        historyItems.assignAll(response.data!.data);
      } else {
        historyItems.clear();
      }
    } catch (e) {
      historyItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchMemberBanks();
    if (selectedTabIndex.value == 1) {
      fetchOngoingSetoran();
    }
  }
}
