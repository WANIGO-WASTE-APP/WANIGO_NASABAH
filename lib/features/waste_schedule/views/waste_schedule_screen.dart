import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_empty_unregistered_bank.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_empty_timetable.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_calendar_widget.dart';
import 'package:wanigo_nasabah/features/waste_schedule/controllers/waste_schedule_controller.dart';

class WasteScheduleScreen extends StatelessWidget {
  const WasteScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.put(WasteScheduleController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        enableShadow: true,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ScheduleCalendarWidget(),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  controller.isRegistered.value
                      ? const ScheduleEmptyTimetable()
                      : const ScheduleEmptyUnregisteredBank(),
                  // Add some bottom padding to prevent being too close to the edge
                  SizedBox(height: 24.h),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
