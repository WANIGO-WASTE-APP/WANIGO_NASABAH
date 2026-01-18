import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            const ScheduleCalendarWidget(),
          ],
        ),
      ),
    );
  }
}
