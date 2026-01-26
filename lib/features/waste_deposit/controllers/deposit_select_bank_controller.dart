import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_controller.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

class DepositSelectBankController extends GetxController {
  // Dependencies
  final WasteBankController wasteBankController =
      Get.find<WasteBankController>();

  // State
  final Rx<WasteBankModel?> selectedWasteBank = Rx<WasteBankModel?>(null);

  void handleBack() {
    Get.find<HomeController>().currentIndex.value = 0;
  }

  void selectWasteBank(WasteBankModel wasteBank) {
    selectedWasteBank.value = wasteBank;
    Get.toNamed(
      Routes.setoranSampahAdd,
      arguments: wasteBank,
    );
  }

  Future<void> refreshWasteBanks() async {
    await wasteBankController.refreshData();
  }
}
