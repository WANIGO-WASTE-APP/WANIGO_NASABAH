import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_detail_controller.dart';

class DepositHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositHistoryDetailController>(
      () => DepositHistoryDetailController(),
    );
  }
}
