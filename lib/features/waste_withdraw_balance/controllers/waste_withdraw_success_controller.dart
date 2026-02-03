import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

class WasteWithdrawSuccessController extends GetxController {
  void navigateHome() {
    Get.offAllNamed(Routes.home);
  }

  void navigateToStatus() {
    // Navigate back to the home screen and set tab to history (index 1)
    Get.offAllNamed(Routes.home);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().onBottomNavTapped(1);
    }
  }
}
