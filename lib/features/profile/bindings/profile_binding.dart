import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/profile/controllers/profile_step_controller.dart';
import 'package:wanigo_nasabah/features/profile/controllers/profile_controller.dart';
import 'package:wanigo_nasabah/features/profile/controllers/account_settings_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy-singleton pattern untuk ProfileStepController
    Get.lazyPut<ProfileStepController>(() => ProfileStepController(), fenix: true);
    
    // Tambahkan ProfileController untuk halaman profil utama
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);

    // Tambahkan AccountSettingsController
    Get.lazyPut<AccountSettingsController>(() => AccountSettingsController(), fenix: true);
  }
}