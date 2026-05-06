import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/create_pemilahan_schedule_screen.dart';
import 'package:wanigo_nasabah/features/waste_schedule/views/create_setoran_schedule_screen.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class SelectScheduleTypeScreen extends StatelessWidget {
  const SelectScheduleTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(
        enableShadow: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                GlobalHeader(
                  title: 'Pilih Tipe Jadwal 📅',
                  subtitle:
                      'Pilih jadwal pemilahan atau pengajuan setoran sesuai kebutuhan Anda',
                ),
                const SizedBox(height: 24),

                _buildScheduleTypeCard(
                  title: 'Jadwal Pemilahan Sampah',
                  description:
                      'Atur jadwal pemilahan sampah agar pengumpulan lebih efisien',
                  iconPath: 'assets/icons/pemilahan_icon.svg',
                  onTap: () {
                    Get.to(() => const CreatePemilahanScheduleScreen());
                  },
                ),
                const SizedBox(height: 16),

                // Jadwal Rencana Setoran Card
                _buildScheduleTypeCard(
                  title: 'Jadwal Rencana Setoran',
                  description:
                      'Pilih tanggal ajuan setoran sampah hingga 7 hari sebelum penyetoran',
                  iconPath: 'assets/icons/setoran_icon.svg',
                  onTap: () {
                    Get.to(() => const CreateSetoranScheduleScreen());
                  },
                ),
              ],
            ),
          ),
          // Background image at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/icons/plan_typebg.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTypeCard({
    required String title,
    required String description,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GlobalText(
                          text: title,
                          variant: TextVariant.largeSemiBold,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        GlobalText(
                          text: description,
                          variant: TextVariant.smallRegular,
                          color: AppColors.gray600,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: SvgPicture.asset(
                    'assets/icons/waves_right_icon.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
