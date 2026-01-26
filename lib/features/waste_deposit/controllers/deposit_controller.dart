import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_controller.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/features/waste_deposit/views/deposit_waste_form_screen.dart';

class DepositController extends GetxController {
  // Dependency
  final WasteBankController wasteBankController =
      Get.find<WasteBankController>();
  final AuthRepository _authRepository = AuthRepository();

  // State
  final Rx<WasteBankModel?> selectedWasteBank = Rx<WasteBankModel?>(null);
  final RxInt selectedTabIndex = 0.obs;
  final RxList<WasteSubCategory> subCategories = <WasteSubCategory>[].obs;
  final Rx<int?> selectedSubCategoryIndex = Rx<int?>(null);
  final RxBool isSubCategoryLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void handleBack() {
    Get.find<HomeController>().currentIndex.value = 0;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    fetchSubKategori();
  }

  void selectWasteBank(WasteBankModel wasteBank) {
    if (kDebugMode) print("DEBUG - Selecting Waste Bank: ${wasteBank.name}");
    selectedWasteBank.value = wasteBank;
    fetchSubKategori();
    Get.to(() => const DepositWasteFormScreen());
  }

  Future<void> fetchSubKategori() async {
    if (selectedWasteBank.value == null) {
      if (kDebugMode)
        print("DEBUG - fetchSubKategori aborted: selectedWasteBank is NULL");
      return;
    }

    try {
      isSubCategoryLoading.value = true;
      selectedSubCategoryIndex.value = null;

      final String kodeKategori =
          selectedTabIndex.value == 0 ? 'kering' : 'basah';

      if (kDebugMode)
        print(
            "DEBUG - Fetching SubKategori for ID: ${selectedWasteBank.value!.id}, Kategori: $kodeKategori");

      final result = await _authRepository.getSubKategori(
        selectedWasteBank.value!.id,
        kodeKategori,
      );

      if (kDebugMode)
        print(
            "DEBUG - Received ${result.length} sub-categories from repository");

      subCategories.assignAll(result);
    } catch (e) {
      if (kDebugMode) print("DEBUG - Error in fetchSubKategori: $e");
      Get.snackbar('Error', 'Gagal memuat sub kategori: $e');
    } finally {
      isSubCategoryLoading.value = false;
    }
  }

  void selectSubCategory(int index) {
    selectedSubCategoryIndex.value = index;
  }

  Future<void> refreshWasteBanks() async {
    await wasteBankController.refreshData();
  }
}
