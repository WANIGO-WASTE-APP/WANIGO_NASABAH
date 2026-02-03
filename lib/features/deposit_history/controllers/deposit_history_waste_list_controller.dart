import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_history_model.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_item_detail_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class DepositHistoryWasteListController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final Rx<WasteDepositHistoryModel?> deposit =
      Rx<WasteDepositHistoryModel?>(null);
  final RxList<WasteDepositItemDetailModel> wasteItems =
      <WasteDepositItemDetailModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  final RxSet<int> selectedItemIds = <int>{}.obs;

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      selectedItemIds.clear();
    }
  }

  void toggleSelection(int id) {
    if (selectedItemIds.contains(id)) {
      selectedItemIds.remove(id);
    } else {
      selectedItemIds.add(id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is WasteDepositHistoryModel) {
      deposit.value = Get.arguments as WasteDepositHistoryModel;
      fetchWasteItems(deposit.value!.id);
    }
  }

  Future<void> fetchWasteItems(int id) async {
    try {
      isLoading.value = true;
      final items = await _authRepository.getWasteDepositItems(id);
      wasteItems.assignAll(items);
    } catch (e) {
      wasteItems.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
