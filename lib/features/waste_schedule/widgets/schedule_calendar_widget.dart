import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_schedule/controllers/waste_schedule_controller.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class ScheduleCalendarWidget extends GetView<WasteScheduleController> {
  const ScheduleCalendarWidget({Key? key}) : super(key: key);

  List<DateTime> _getDaysInMonth(DateTime currentMonth) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final days = <DateTime>[];

    // Empty slots for days before the first day of month
    final weekdayOfFirstDay = firstDay.weekday % 7; // 0 = Sunday
    for (int i = 0; i < weekdayOfFirstDay; i++) {
      days.add(firstDay.subtract(Duration(days: weekdayOfFirstDay - i)));
    }

    // All days in the current month
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month, i + 1));
    }

    // Days from next month
    final remainingSlots = (7 - (days.length % 7)) % 7;
    for (int i = 1; i <= remainingSlots; i++) {
      days.add(DateTime(currentMonth.year, currentMonth.month + 1, i));
    }

    return days;
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB9D1FF).withValues(alpha: 0.35),
      ),
      child: Stack(
        children: [
          Obx(() => controller.isCalendarExpanded.value
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.3, // 0.0 – 1.0
                    child: SvgPicture.asset(
                      'assets/images/plants_image.svg',
                      fit: BoxFit.cover,
                    ),
                  ))
              : const SizedBox.shrink()),

          // Calendar content
          Obx(() {
            final currentMonth = controller.currentMonth.value;
            final days = _getDaysInMonth(currentMonth);

            return Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r,
                  controller.isCalendarExpanded.value ? 8.r : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Month/Year header with navigation
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/calendar_arrow_left_icon.svg',
                          width: 24.r,
                          height: 24.r,
                        ),
                        onPressed: controller.previousMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      GlobalText(
                        text:
                            '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                        variant: TextVariant.mediumBold,
                        color: AppColors.blue600,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/calendar_arrow_right_icon.svg',
                          width: 24.r,
                          height: 24.r,
                        ),
                        onPressed: controller.nextMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Spacer(),
                      Transform.translate(
                        offset: Offset(18.w, 0),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/calendar_icon.svg',
                            width: 28.r,
                            height: 28.r,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          controller.isCalendarExpanded.value
                              ? 'assets/icons/schedule_arrow_up_icon.svg'
                              : 'assets/icons/schedule_arrow_down_icon.svg',
                          width: 16.r,
                          height: 16.r,
                        ),
                        onPressed: controller.toggleCalendarExpanded,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                        .map((day) => SizedBox(
                              width: 40.w,
                              child: Center(
                                child: GlobalText(
                                  text: day,
                                  variant: TextVariant.smallBold,
                                  color: AppColors.blue600,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),

                  // Calendar grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.3,
                    ),
                    itemCount:
                        controller.isCalendarExpanded.value ? days.length : 7,
                    itemBuilder: (context, index) {
                      final date = days[index];
                      final isCurrentMonth = date.month == currentMonth.month;

                      final isSelected = controller.isDateSelected(date);

                      return Container(
                        margin: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.blue500
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: GlobalText(
                            text: '${date.day}',
                            variant: TextVariant.smallBold,
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? AppColors.blue600
                                    : AppColors.gray600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
