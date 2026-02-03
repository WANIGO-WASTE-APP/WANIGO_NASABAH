import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';

class DepositTimelineStatus extends StatelessWidget {
  final String status;
  final DateTime date;

  const DepositTimelineStatus({
    super.key,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormatter.formatMediumDate(date);
    final String lowerStatus = status.toLowerCase();

    final bool isDiprosesState =
        ['diproses', 'dalam proses'].contains(lowerStatus);
    final bool isSelesaiState = ['selesai', 'berhasil'].contains(lowerStatus);

    final bool isPengajuanActive = true;
    final bool isDiprosesActive = isDiprosesState || isSelesaiState;
    final bool isSelesaiActive = isSelesaiState;

    final bool isFirstLineActive = isDiprosesActive;
    final bool isSecondLineActive = isSelesaiActive;

    String pengajuanIcon = 'assets/icons/submission_active_icon.svg';
    String diprosesIcon = isDiprosesActive
        ? 'assets/icons/processed_active_icon.svg'
        : 'assets/icons/processed_disabled_icon.svg';
    String selesaiIcon = isSelesaiActive
        ? 'assets/icons/completed_active_icon.svg'
        : 'assets/icons/completed_disabled_icon.svg';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timelineItem(
              icon: pengajuanIcon,
              label: 'Pengajuan',
              date: formattedDate,
              isActive: isPengajuanActive,
            ),
            _line(isActive: isFirstLineActive),
            _timelineItem(
              icon: diprosesIcon,
              label: 'Diproses',
              date: isDiprosesState ? formattedDate : '-',
              isActive: isDiprosesActive,
            ),
            _line(isActive: isSecondLineActive),
            _timelineItem(
              icon: selesaiIcon,
              label: 'Selesai',
              date: isSelesaiState ? formattedDate : '-',
              isActive: isSelesaiActive,
            ),
          ],
        ),
      ],
    );
  }

  Widget _timelineItem({
    required String icon,
    required String label,
    required String date,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue100 : Color(0xFFF2F2F2),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.blue600 : AppColors.gray300,
              width: 1.82.w,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 48,
              height: 48,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GlobalText(
          text: label,
          variant: TextVariant.smallBold,
          color: AppColors.gray700,
        ),
        const SizedBox(height: 4),
        GlobalText(
          text: date,
          variant: TextVariant.xSmallMedium,
          color: AppColors.gray700,
        ),
      ],
    );
  }

  Widget _line({required bool isActive}) {
    return Container(
      width: 44,
      height: 4,
      margin: const EdgeInsets.only(top: 39),
      color: isActive ? AppColors.blue600 : AppColors.blue200,
    );
  }
}
