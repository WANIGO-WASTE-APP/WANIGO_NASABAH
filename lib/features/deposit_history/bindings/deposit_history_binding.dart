import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_controller.dart';

class DepositHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositHistoryController>(() => DepositHistoryController());
  }
}
