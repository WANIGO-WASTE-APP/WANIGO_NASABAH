import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/data/models/schedule_list_model.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleItemModel schedule;
  final VoidCallback? onTap;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color:
                schedule.tipeJadwal.tipeJadwal.toLowerCase().contains('setoran')
                    ? AppColors.green100
                    : AppColors.blue100,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left border indicator
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: schedule.leftBorderColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GlobalText(
                              text: schedule.scheduleTypeLabel,
                              variant: TextVariant.mediumSemiBold,
                              color: AppColors.gray700,
                            ),
                            const SizedBox(height: 4),
                            if (schedule.tipeJadwal.tipeJadwal
                                .toLowerCase()
                                .contains('setoran'))
                              GlobalText(
                                text: schedule.bankSampah.namaBankSampah,
                                variant: TextVariant.smallRegular,
                                color: AppColors.gray600,
                              )
                            else
                              GlobalText(
                                text: 'Mulai tanggal ${schedule.formattedDate}',
                                variant: TextVariant.smallRegular,
                                color: AppColors.gray600,
                              ),
                            if (schedule.tipeJadwal.tipeJadwal
                                .toLowerCase()
                                .contains('setoran')) ...[
                              const SizedBox(height: 2),
                              GlobalText(
                                text: 'Mulai tanggal ${schedule.formattedDate}',
                                variant: TextVariant.smallRegular,
                                color: AppColors.gray600,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: schedule.chipBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: GlobalText(
                          text: schedule.frequencyLabel,
                          variant: TextVariant.smallMedium,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
