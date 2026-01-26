import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';

class DepositSuccessController extends GetxController {
  void navigateToStatus() {
    final homeController = Get.find<HomeController>();
    homeController.currentIndex.value = 0;
    homeController.refreshHomeData();
    Get.until((route) => route.settings.name == Routes.home);
  }

  void navigateHome() {
    final homeController = Get.find<HomeController>();
    homeController.currentIndex.value = 0;
    homeController.refreshHomeData();
    Get.until((route) => route.settings.name == Routes.home);
  }
}
