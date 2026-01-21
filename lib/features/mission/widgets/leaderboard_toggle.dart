import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardToggle extends StatelessWidget {
  const LeaderboardToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaderboardController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _segmentButton('Mingguan', controller, true),
            _segmentButton('Bulanan', controller, false),
          ],
        ),
      ),
    );
  }

  Widget _segmentButton(
      String text, LeaderboardController controller, bool targetValue) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setWeekly(targetValue),
        child: Obx(() {
          final active = controller.isWeekly.value == targetValue;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: active ? AppColors.blue600 : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: GlobalText(
                text: text,
                color: active ? Colors.white : AppColors.blue600,
                variant: TextVariant.mediumSemiBold,
              ),
            ),
          );
        }),
      ),
    );
  }
}
