import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/routes/app_pages.dart';
import 'package:flutter/foundation.dart' show kDebugMode;


void main() {
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
                if (routing.args != null) {
                  print("DEBUG - With arguments: ${routing.args}");
                }
              }
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
              child: widget,
            );
          },
        );
      },
    );
  }
}
