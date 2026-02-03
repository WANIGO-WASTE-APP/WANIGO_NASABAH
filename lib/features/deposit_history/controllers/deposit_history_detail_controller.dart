import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_history_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class DepositHistoryDetailController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final Rx<WasteDepositHistoryModel?> deposit =
      Rx<WasteDepositHistoryModel?>(null);
  final RxString statusSetoran = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isNotesExpanded = false.obs;

  void toggleNotesExpanded() {
    isNotesExpanded.value = !isNotesExpanded.value;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is WasteDepositHistoryModel) {
      deposit.value = Get.arguments as WasteDepositHistoryModel;
      statusSetoran.value = deposit.value!.statusSetoran;
      fetchDepositDetail(deposit.value!.id);
    } else if (Get.arguments is int) {
      fetchDepositDetail(Get.arguments as int);
    }
  }

  Future<void> fetchDepositDetail(int id) async {
    try {
      isLoading.value = true;
      final result = await _authRepository.getWasteDepositDetail(id);
      if (result != null) {
        deposit.value = result;
        statusSetoran.value = result.statusSetoran;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(String newStatus) {
    statusSetoran.value = newStatus;
  }
}
