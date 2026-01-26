import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_select_bank_controller.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_waste_form_controller.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_success_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_controller.dart';

class DepositBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WasteBankController>(() => WasteBankController());
    Get.lazyPut<DepositSelectBankController>(
        () => DepositSelectBankController());
    Get.lazyPut<DepositWasteFormController>(() => DepositWasteFormController());
    Get.lazyPut<DepositSuccessController>(() => DepositSuccessController());
  }
}
