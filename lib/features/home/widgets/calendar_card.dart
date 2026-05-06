import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/data/models/schedule_list_model.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/waste_schedule_screen.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/calendar_schedule_model.dart';

class CalendarProfile extends StatelessWidget {
  final CalendarScheduleModel schedule;
  final List<ScheduleItemModel>? schedules;

  const CalendarProfile({
    super.key,
    required this.schedule,
    this.schedules,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateBox(context),
        SizedBox(width: 12.w),
        if (schedules != null && schedules!.isNotEmpty)
          Expanded(
            child: Column(
              children:
                  schedules!.map((item) => _buildScheduleItem(item)).toList(),
            ),
          )
        else
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 5.w,
                        decoration: BoxDecoration(
                          color: AppColors.blue500,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: GlobalText(
                          text: schedule.message,
                          variant: TextVariant.xSmallBold,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: GlobalButton(
                    text: 'Atur jadwal sekarang',
                    variant: ButtonVariant.small,
                    onPressed: () {
                      Get.to(() => const WasteScheduleScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildScheduleItem(ScheduleItemModel item) {
    final isSetoran =
        item.tipeJadwal.tipeJadwal.toLowerCase().contains('setoran');
    final borderColor =
        isSetoran ? const Color(0xFF2E7D32) : const Color(0xFF1B4BFF);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(
        item.tanggalMulai.year, item.tanggalMulai.month, item.tanggalMulai.day);
    final daysRemaining = scheduleDate.difference(today).inDays;
    final daysText = daysRemaining > 0
        ? '($daysRemaining hari lagi)'
        : daysRemaining == 0
            ? '(Hari ini)'
            : '(${daysRemaining.abs()} hari yang lalu)';

    return GestureDetector(
      onTap: () {
        Get.to(() => const WasteScheduleScreen());
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 5.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlobalText(
                    text: isSetoran
                        ? 'Jadwal Setoran ${item.bankSampah.namaBankSampah}'
                        : 'Jadwal Pemilahan Sampah #${item.nomorUrut}',
                    variant: TextVariant.smallSemiBold,
                    color: AppColors.gray700,
                  ),
                  SizedBox(height: 2.h),
                  GlobalText(
                    text: '${item.formattedDate} $daysText',
                    variant: TextVariant.xSmallRegular,
                    color: AppColors.gray600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(BuildContext context) {
    return Container(
      width: 85.w,
      height: 92.h,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_calendar.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Stack(
                children: [
                  // Stroke Layer (Behind)
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF004DFF),
                        Color(0xFF009CFF),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      '${schedule.day}',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: -1.08,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.white,
                      ),
                    ),
                  ),
                  // Fill Layer (Front)
                  Text(
                    '${schedule.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito Sans',
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -1.08,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Color.fromRGBO(13, 13, 18, 0.18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              Stack(
                children: [
                  // Stroke Layer (Behind)
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF004DFF),
                        Color(0xFF009CFF),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      schedule.month,
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        letterSpacing: -0.42,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.white,
                      ),
                    ),
                  ),
                  // Fill Layer (Front)
                  Text(
                    schedule.month,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito Sans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -0.42,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2.0,
                          color: Color.fromRGBO(13, 13, 18, 0.12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(999),
            ),
            child: GlobalText(
              text: schedule.weekday,
              variant: TextVariant.xSmallSemiBold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
