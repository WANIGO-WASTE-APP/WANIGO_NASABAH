import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pengajuan':
      case 'diproses':
      case 'selesai':
        return AppColors.blue600;
      case 'dibatalkan':
        return AppColors.red600;
      default:
        return AppColors.gray600;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'pengajuan':
      case 'diproses':
      case 'selesai':
        return AppColors.blue100;
      case 'dibatalkan':
        return AppColors.red100;
      default:
        return AppColors.gray100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final bgColor = _getStatusBackgroundColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 6.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color, width: 1.w),
      ),
      child: GlobalText(
        text: status.isNotEmpty
            ? "${status[0].toUpperCase()}${status.substring(1).toLowerCase()}"
            : status,
        variant: TextVariant.smallSemiBold,
        color: color,
      ),
    );
  }
}
