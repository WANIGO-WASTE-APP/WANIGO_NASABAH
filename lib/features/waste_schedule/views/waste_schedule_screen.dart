import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_calendar_widget.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class WasteScheduleScreen extends StatefulWidget {
  const WasteScheduleScreen({Key? key}) : super(key: key);

  @override
  State<WasteScheduleScreen> createState() => _WasteScheduleScreenState();
}

class _WasteScheduleScreenState extends State<WasteScheduleScreen> {
  List<DateTime> _selectedDates = [];

  @override
  Widget build(BuildContext context) {
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
            ScheduleCalendarWidget(
              selectedDates: _selectedDates,
              onDatesChanged: (dates) {
                setState(() {
                  _selectedDates = dates;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
