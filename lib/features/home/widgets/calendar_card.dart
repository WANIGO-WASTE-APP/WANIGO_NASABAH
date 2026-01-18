import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/calendar_schedule_model.dart';

class CalendarProfile extends StatelessWidget {
  final CalendarScheduleModel schedule;

  const CalendarProfile({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDateBox(context),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildJadwalPemilahan(),
              SizedBox(height: 8.h),
              _buildJadwalSetoran(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalPemilahan() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                text: 'Jadwal Pemilahan Sampah #1',
                variant: TextVariant.smallSemiBold,
              ),
              SizedBox(height: 2.h),
              GlobalText(
                text: DateFormat('d MMMM yyyy', 'id').format(DateTime.now()),
                variant: TextVariant.xSmallRegular,
                color: AppColors.gray600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalSetoran() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                text: 'Jadwal Setoran Bank Sampah',
                variant: TextVariant.smallSemiBold,
              ),
              SizedBox(height: 2.h),
              GlobalText(
                text: DateFormat('d MMMM yyyy', 'id').format(DateTime.now()),
                variant: TextVariant.xSmallRegular,
                color: AppColors.gray600,
              ),
            ],
          ),
        ),
      ],
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
