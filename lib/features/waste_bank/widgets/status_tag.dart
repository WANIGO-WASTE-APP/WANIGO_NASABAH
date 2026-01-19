import 'package:flutter/material.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class StatusTag extends StatelessWidget {
  final bool isActive;

  const StatusTag({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.gray100,
        ),
      ),
      child: Center(
        child: GlobalText(
          text: isActive ? 'Buka' : 'Tutup',
          variant: TextVariant.xSmallMedium,
          color: isActive ? AppColors.green600 : AppColors.red600,
        ),
      ),
    );
  }
}
