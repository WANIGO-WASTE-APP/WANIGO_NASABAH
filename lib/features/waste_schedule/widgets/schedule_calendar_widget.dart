import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class ScheduleCalendarWidget extends StatefulWidget {
  final List<DateTime> selectedDates;
  final Function(List<DateTime>)? onDatesChanged;

  const ScheduleCalendarWidget({
    Key? key,
    this.selectedDates = const [],
    this.onDatesChanged,
  }) : super(key: key);

  @override
  State<ScheduleCalendarWidget> createState() => _ScheduleCalendarWidgetState();
}

class _ScheduleCalendarWidgetState extends State<ScheduleCalendarWidget> {
  late DateTime _currentMonth;
  late List<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDates = List.from(widget.selectedDates);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isDateSelected(DateTime date) {
    return _selectedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final days = <DateTime>[];

    // Add empty slots for days before the first day of month
    final weekdayOfFirstDay = firstDay.weekday % 7; // 0 = Sunday
    for (int i = 0; i < weekdayOfFirstDay; i++) {
      days.add(firstDay.subtract(Duration(days: weekdayOfFirstDay - i)));
    }

    // Add all days in the current month
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, i + 1));
    }

    // Add days from next month to complete the grid
    final remainingSlots = (7 - (days.length % 7)) % 7;
    for (int i = 1; i <= remainingSlots; i++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, i));
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
    final days = _getDaysInMonth();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB9D1FF).withValues(alpha: 0.35),
      ),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.3, // 0.0 – 1.0
                child: SvgPicture.asset(
                  'assets/images/plants_image.svg',
                  fit: BoxFit.cover,
                ),
              )),

          // Calendar content
          Padding(
            padding: EdgeInsets.all(16.r),
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
                      onPressed: _previousMonth,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    GlobalText(
                      text:
                          '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                      variant: TextVariant.largeBold,
                      color: AppColors.blue600,
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/calendar_arrow_right_icon.svg',
                        width: 24.r,
                        height: 24.r,
                      ),
                      onPressed: _nextMonth,
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
                        'assets/icons/arrow_up_icon.svg',
                        width: 16.r,
                        height: 16.r,
                      ),
                      onPressed: () {},
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final date = days[index];
                    final isCurrentMonth = date.month == _currentMonth.month;
                    final isSelected = _isDateSelected(date);

                    return Container(
                      margin: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.blue500 : Colors.transparent,
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
          ),
        ],
      ),
    );
  }
}
