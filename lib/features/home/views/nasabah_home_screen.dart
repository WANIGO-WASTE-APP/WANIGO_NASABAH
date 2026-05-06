import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/data/models/profile_model.dart';
import 'package:wanigo_nasabah/data/models/tabungan_model.dart';
import 'package:wanigo_nasabah/data/models/calendar_schedule_model.dart';
import 'package:wanigo_nasabah/data/models/setoran_sampah_model.dart';
import 'package:wanigo_nasabah/features/home/widgets/profile_card.dart';
import 'package:wanigo_nasabah/features/home/widgets/tabungan_saldo.dart';
import 'package:wanigo_nasabah/features/home/widgets/calendar_card.dart';
import 'package:wanigo_nasabah/features/home/widgets/setoran_sampah_card.dart';
import 'package:wanigo_nasabah/features/home/widgets/bottom_nav_bar.dart';
import 'package:wanigo_nasabah/features/home/widgets/feature_icons_section.dart';
import 'package:wanigo_nasabah/features/home/widgets/home_floating_action_button.dart';
import 'package:wanigo_nasabah/features/home/widgets/home_background.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';

class NasabahHomeScreen extends GetView<HomeController> {
  const NasabahHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background layer
          const HomeBackground(),

          // Content layer
          RefreshIndicator(
            onRefresh: controller.refreshHomeData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Leaf Illustration
                  Positioned(
                    top: 200.h,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/icons/leaf_illustration_icon.svg',
                      width: double.infinity,
                      height: 220.h,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 8.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Card
                            Obx(() => ProfileCard(
                                  profile: ProfileModel(
                                    userName: controller.userName,
                                    points: controller.userPoints,
                                    profilePhotoUrl:
                                        controller.user?.profilePhotoUrl,
                                    address: controller.address.value,
                                    bankSampahName:
                                        controller.bankSampahName.value,
                                  ),
                                )),

                            SizedBox(height: 14.h),

                            // Tabungan Card
                            TabunganCard(
                              tabungan: TabunganModel(
                                saldo: 24000.00,
                                beratSampah: 12,
                              ),
                            ),

                            SizedBox(height: 38.h),
                          ],
                        ),
                      ),

                      // Features and Setoran
                      Container(
                        width: double.infinity, // Full width
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Calendar Card
                            Transform.translate(
                              offset: Offset(0, -36.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.r),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: const Color(0xFFCACACA)),
                                    boxShadow: GlobalShadow.getShadow(
                                        ShadowVariant.medium),
                                  ),
                                  padding: EdgeInsets.all(12.r),
                                  child: Obx(() => CalendarProfile(
                                        schedule: CalendarScheduleModel.today(
                                          message:
                                              'Jadwal Pemilahan/Penyetoran Sampah Anda Belum Dibuat.',
                                        ),
                                        schedules: controller.hasSchedules.value
                                            ? controller.scheduleList.toList()
                                            : null,
                                      )),
                                ),
                              ),
                            ),

                            Transform.translate(
                              offset: Offset(0, -20.h),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 20.r,
                                  right: 20.r,
                                  top: 0,
                                  bottom: 15.r,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Features Section
                                    GlobalText(
                                      text: 'Fitur Aplikasi WANIGO!',
                                      variant: TextVariant.h5,
                                      color: AppColors.gray600,
                                    ),

                                    SizedBox(height: 16.h),

                                    const FeatureIconsSection(),

                                    SizedBox(height: 32.h),

                                    // Setoran Section
                                    GlobalText(
                                      text: 'Setoran Sampah Terkini',
                                      variant: TextVariant.h5,
                                    ),

                                    SizedBox(height: 16.h),

                                    SetoranSampahCard(
                                      setoran: SetoranSampahModel(
                                        title: 'Buat Rencana Setoran',
                                        description:
                                            'Mulai ajukan setoran sampah Anda & berkontribusi menjaga lingkungan',
                                      ),
                                    ),

                                    SizedBox(height: 10.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: HomeFloatingActionButton(
        onPressed: () => controller.onBottomNavTapped(2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return GlobalAppBar(
      centerTitle: false,
      showBackButton: false,
      titleSpacing: 20.r,
      showNotification: true,
    );
  }
}
