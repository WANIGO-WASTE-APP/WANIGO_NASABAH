import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class WasteBankSearchController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxList<WasteBankModel> allWasteBanks = <WasteBankModel>[].obs;
  final RxList<WasteBankModel> filteredWasteBanks = <WasteBankModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableWasteBanks();
  }

  Future<void> fetchAvailableWasteBanks() async {
    try {
      isLoading.value = true;

      final allBanks = await _authRepository.getAvailableBankSampah();

      final memberResponse = await _authRepository.getMemberBankSampah();
      final List<int> registeredIds =
          memberResponse?.bankSampah.map((b) => b.id).toList() ?? [];

      final crossReferencedBanks = allBanks.map((bank) {
        if (registeredIds.contains(bank.id)) {
          return bank.copyWith(isVerified: true);
        }
        return bank;
      }).toList();

      crossReferencedBanks.sort((a, b) => a.id.compareTo(b.id));

      allWasteBanks.assignAll(crossReferencedBanks);
      filteredWasteBanks.assignAll(crossReferencedBanks);
    } catch (e) {
      print("Error fetching available waste banks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchWasteBanks(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredWasteBanks.assignAll(allWasteBanks);
    } else {
      filteredWasteBanks.assignAll(
        allWasteBanks.where((wb) =>
            wb.name.toLowerCase().contains(query.toLowerCase()) ||
            wb.address.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
