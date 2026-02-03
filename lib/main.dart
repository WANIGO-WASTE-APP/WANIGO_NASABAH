import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/routes/app_pages.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:wanigo_nasabah/core/config/alice_config.dart';

import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);

  if (kDebugMode) {
    print("DEBUG - Starting Wanigo Nasabah App");
  }

  // Set log level untuk GetX
  Get.config(
    enableLog: true,
    logWriterCallback: (String text, {bool isError = false}) {
      if (kDebugMode) {
        if (isError) {
          print("ERROR - $text");
        } else {
          print("GetX - $text");
        }
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 16 size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: alice.getNavigatorKey(),
          title: 'Wanigo Nasabah',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: Routes.splash,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          // Handler untuk error navigasi
          unknownRoute: GetPage(
            name: '/not-found',
            page: () => const Scaffold(
              body: Center(
                child: Text('Halaman tidak ditemukan'),
              ),
            ),
          ),
          // Logging untuk navigasi
          routingCallback: (routing) {
            if (kDebugMode) {
              if (routing?.current != null) {
                print("DEBUG - Navigating to: ${routing!.current}");
              }
            }
            if (routing?.current != null) {
              try {
                if (Get.isRegistered<HomeController>()) {
                  final controller = Get.find<HomeController>();
                  final String currentRoute = routing!.current;
                  if (currentRoute == Routes.home) {
                    controller.currentIndex.value = 0;
                  } else if (currentRoute == Routes.setoranHistory) {
                    controller.currentIndex.value = 1;
                  } else if (currentRoute == Routes.depositSelectBank) {
                    controller.currentIndex.value = 2;
                  } else if (currentRoute == Routes.profile) {
                    controller.currentIndex.value = 4;
                  }
                }
              } catch (_) {}
            }
          },
          // Log error builder
          onInit: () {
            if (kDebugMode) {
              print("DEBUG - GetMaterialApp initialized");
            }
          },
          // Error fallback
          builder: (context, widget) {
            // Add error handling
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              if (kDebugMode) {
                print("ERROR - Flutter Error: ${errorDetails.exception}");
                print("ERROR - Stack Trace: ${errorDetails.stack}");
              }
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Terjadi kesalahan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (kDebugMode)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorDetails.exception.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            };

            // Add tap wrapper to allow dismissing of keyboard
            return GestureDetector(
              onTap: () {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: Stack(
                children: [
                  widget!,
                  if (kDebugMode)
                    Positioned(
                      bottom: 100,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'alice_floating_button',
                        onPressed: () {
                          alice.showInspector();
                        },
                        child: const Icon(Icons.bug_report),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
