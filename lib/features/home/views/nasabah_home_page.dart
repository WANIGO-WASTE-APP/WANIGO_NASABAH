import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:get/get.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/features/auth/controllers/auth_controller.dart';
import 'package:wanigo_nasabah/features/home/views/nasabah_home_screen.dart';

class NasabahHomePage extends StatelessWidget {
  const NasabahHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      // Make sure user is logged in before proceeding
      if (!authController.isLoggedIn.value) {
        // Only redirect if not already navigating to login
        if (Get.currentRoute != Routes.login) {
          Future.microtask(() => Get.offAllNamed(Routes.login));
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return const NasabahHomeScreen();
    });
  }
}
