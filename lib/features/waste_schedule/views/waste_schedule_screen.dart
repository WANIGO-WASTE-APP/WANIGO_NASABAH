import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_card.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_empty_unregistered_bank.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_empty_timetable.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/data/models/schedule_list_model.dart';
import 'package:wanigo_nasabah/features/waste_schedule/widgets/schedule_calendar_widget.dart';
import 'package:wanigo_nasabah/features/waste_schedule/controllers/waste_schedule_controller.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/select_schedule_type_screen.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/schedule_success_screen.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class WasteScheduleScreen extends StatelessWidget {
  const WasteScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteScheduleController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        enableShadow: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: ScheduleCalendarWidget(),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.hasSchedules.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GlobalText(
                          text: 'Daftar Jadwal Sampah Sudah Terbuat',
                          variant: TextVariant.largeSemiBold,
                          color: AppColors.gray700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Schedule Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: controller.scheduleList.map((schedule) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: ScheduleCard(
                                schedule: schedule,
                                onTap: () {
                                  _showScheduleActionModal(
                                      context, schedule, controller);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Buat Jadwal Baru button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const SelectScheduleTypeScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue700,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Buat Jadwal Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  );
                }

                // Empty state
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    controller.isRegistered.value
                        ? const ScheduleEmptyTimetable()
                        : const ScheduleEmptyUnregisteredBank(),
                    SizedBox(height: 24.h),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleActionModal(BuildContext context,
      ScheduleItemModel schedule, WasteScheduleController controller) {
    final isSetoran =
        schedule.tipeJadwal.tipeJadwal.toLowerCase().contains('setoran');
    final title = isSetoran ? 'Mulai Setoran Sampah' : 'Mulai Pemilahan Sampah';
    final description = isSetoran
        ? 'Lapor hasil setoran sampah Anda untuk menyelesaikan jadwal setoran hari ini'
        : 'Lapor hasil pemilahan sampah Anda untuk menyelesaikan jadwal pemilahan hari ini';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                child: Center(
                  child: Image.asset(
                    'assets/images/trash_recycle.png',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              GlobalText(
                text: title,
                variant: TextVariant.largeBold,
                color: AppColors.gray700,
              ),
              const SizedBox(height: 12),
              // Description
              GlobalText(
                text: description,
                variant: TextVariant.smallRegular,
                color: AppColors.gray600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Button
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final isSetoran = schedule.tipeJadwal.tipeJadwal
                      .toLowerCase()
                      .contains('setoran');

                  // Call API to mark as completed
                  final response =
                      await controller.markScheduleCompleted(schedule.id);

                  if (response['success'] == true) {
                    Get.to(() => ScheduleSuccessScreen(
                          title: isSetoran
                              ? 'Setoran Sampah Sudah Selesai!'
                              : 'Pemilahan Sampah Sudah Selesai!',
                          description: isSetoran
                              ? 'Jadwal setoran sampah berhasil diselesaikan. Terima kasih telah berkontribusi menjaga kebersihan lingkungan! 🌍'
                              : 'Jadwal pemilahan sampah berhasil diselesaikan. Terima kasih telah berkontribusi menjaga kebersihan lingkungan! 🌍',
                        ));
                  } else {
                    // Show error
                    Get.snackbar(
                      'Gagal',
                      response['statusMessage'] ??
                          'Gagal menandai jadwal sebagai selesai',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tandai Selesai',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Kembali button
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue700,
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.blue700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
