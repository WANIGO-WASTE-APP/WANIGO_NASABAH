import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_waste_list_controller.dart';

class DepositHistoryWasteListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositHistoryWasteListController>(
      () => DepositHistoryWasteListController(),
    );
  }
}
