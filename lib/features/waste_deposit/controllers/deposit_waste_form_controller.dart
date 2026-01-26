import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

class DepositWasteFormController extends GetxController {
  // Dependencies
  final AuthRepository _authRepository = AuthRepository();

  // State
  final Rx<WasteBankModel?> wasteBank = Rx<WasteBankModel?>(null);
  final RxInt selectedTabIndex = 0.obs;
  final RxList<WasteSubCategory> subCategories = <WasteSubCategory>[].obs;
  final Rx<int?> selectedSubCategoryIndex = Rx<int?>(null);
  final RxBool isSubCategoryLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  // Waste Items State
  final RxList<WasteCatalogItem> allWasteItems = <WasteCatalogItem>[].obs;
  final RxList<WasteCatalogItem> displayedWasteItems = <WasteCatalogItem>[].obs;
  final RxBool isWasteItemsLoading = false.obs;
  final RxSet<int> selectedWasteItemIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is WasteBankModel) {
      wasteBank.value = Get.arguments as WasteBankModel;
      fetchData();
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    fetchData();
  }

  Future<void> fetchData() async {
    selectedSubCategoryIndex.value = null;
    await Future.wait([
      fetchSubKategori(),
      fetchWasteItems(),
    ]);

    // Filter subCategories: only keep those that have at least one item in allWasteItems
    final filteredSubCategories = subCategories.where((sub) {
      return allWasteItems.any((item) => item.subKategoriSampahId == sub.id);
    }).toList();

    subCategories.assignAll(filteredSubCategories);
  }

  Future<void> fetchSubKategori() async {
    if (wasteBank.value == null) return;

    try {
      isSubCategoryLoading.value = true;

      final String kodeKategori =
          selectedTabIndex.value == 0 ? 'kering' : 'basah';

      if (kDebugMode) {
        print(
            "DEBUG - Fetching SubKategori for ID: ${wasteBank.value!.id}, Kategori: $kodeKategori");
      }

      final result = await _authRepository.getSubKategori(
        wasteBank.value!.id,
        kodeKategori,
      );

      subCategories.assignAll(result);
    } catch (e) {
      if (kDebugMode) print("DEBUG - Error in fetchSubKategori: $e");
    } finally {
      isSubCategoryLoading.value = false;
    }
  }

  Future<void> fetchWasteItems() async {
    if (wasteBank.value == null) return;

    try {
      isWasteItemsLoading.value = true;
      allWasteItems.clear();
      displayedWasteItems.clear();

      final String kodeKategori =
          selectedTabIndex.value == 0 ? 'kering' : 'basah';

      final response = await _authRepository.getWasteCatalog(
        wasteBank.value!.id,
        kodeKategori,
      );

      if (response != null && response.data != null) {
        final items = response.data!.katalogSampah;
        // Sort by ID descending (largest to smallest)
        items.sort((a, b) => b.id.compareTo(a.id));

        allWasteItems.assignAll(items);
        displayedWasteItems.assignAll(allWasteItems);
      }
    } catch (e) {
      if (kDebugMode) print("DEBUG - Error in fetchWasteItems: $e");
    } finally {
      isWasteItemsLoading.value = false;
    }
  }

  void selectSubCategory(int index) {
    if (selectedSubCategoryIndex.value == index) {
      selectedSubCategoryIndex.value = null;
      displayedWasteItems.assignAll(allWasteItems);
    } else {
      selectedSubCategoryIndex.value = index;
      final selectedSubId = subCategories[index].id;

      final filtered = allWasteItems
          .where((item) => item.subKategoriSampahId == selectedSubId)
          .toList();
      displayedWasteItems.assignAll(filtered);
    }
  }

  void selectWasteItem(int itemId) {
    if (selectedWasteItemIds.contains(itemId)) {
      selectedWasteItemIds.remove(itemId);
    } else {
      selectedWasteItemIds.add(itemId);
    }
  }

  Future<void> submitForm() async {
    if (wasteBank.value == null || selectedWasteItemIds.isEmpty) return;

    try {
      isSubmitting.value = true;

      final now = DateTime.now();
      final String tanggalSetoran = DateFormatter.formatApiDate(now);
      final String waktuSetoran = DateFormatter.formatTime(now);

      final result = await _authRepository.submitWasteDeposit(
        bankSampahId: wasteBank.value!.id,
        tanggalSetoran: tanggalSetoran,
        waktuSetoran: waktuSetoran,
        itemIds: selectedWasteItemIds.toList(),
        catatan: "Pengajuan dari aplikasi nasabah",
      );

      if (result['success'] == true) {
        Get.toNamed(Routes.setoranSuccess);
      } else {
        Get.snackbar(
          'Gagal',
          result['statusMessage'] ??
              'Terjadi kesalahan saat mengajukan setoran',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) print("DEBUG - Error in submitForm: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
