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
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';

import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';

class NasabahHomeScreen extends StatefulWidget {
  const NasabahHomeScreen({super.key});

  @override
  State<NasabahHomeScreen> createState() => _NasabahHomeScreenState();
}

class _NasabahHomeScreenState extends State<NasabahHomeScreen> {
  // Controller
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background layer - DCE8FF color
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 513.h,
              color: const Color(0xFFDCE8FF),
            ),
          ),

          // Content layer
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      Obx(() => ProfileCard(
                            profile: ProfileModel(
                              userName: controller.userName,
                              points: controller.userPoints,
                              profilePhotoUrl:
                                  controller.user.value?.profilePhotoUrl,
                              address: controller.address.value,
                              bankSampahName: controller.bankSampahName.value,
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
                              border:
                                  Border.all(color: const Color(0xFFCACACA)),
                              boxShadow:
                                  GlobalShadow.getShadow(ShadowVariant.medium),
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: CalendarProfile(
                              schedule: CalendarScheduleModel.today(
                                message:
                                    'Jadwal Pemilahan/Penyetoran Sampah Anda Belum Dibuat.',
                              ),
                            ),
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

                              _buildFeatureIcons(),

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

                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final isActive = controller.currentIndex.value == 2;

        return Transform.translate(
          offset: Offset(0, 25.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () => controller.onBottomNavTapped(2),
                backgroundColor:
                    isActive ? AppColors.blue800 : AppColors.gray900,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: Colors.white,
                    width: 3.r,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/images/setoran_icon.svg',
                  width: 29.r,
                  height: 29.r,
                ),
              ),
              SizedBox(height: 4.h),
              GlobalText(
                text: 'Penjualan',
                variant: TextVariant.xSmallMedium,
                color: isActive ? AppColors.blue600 : AppColors.gray900,
              ),
            ],
          ),
        );
      }),
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

  Widget _buildFeatureIcons() {
    final features = [
      {
        'label': 'Edukasi',
        'svg': 'assets/icons/edukasi_icon.svg',
      },
      {
        'label': 'Laporan',
        'svg': 'assets/icons/laporan_icon.svg',
      },
      {
        'label': 'Juara',
        'svg': 'assets/icons/juara_icon.svg',
      },
      {
        'label': 'Misi',
        'svg': 'assets/icons/misi_icon.svg',
      },
      {
        'label': 'Lainnya',
        'svg': 'assets/icons/lainnya_icon.svg',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: features.map((f) {
        return Column(
          children: [
            SvgPicture.asset(
              f['svg'] as String,
              width: 56.r,
              height: 56.r,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            GlobalText(
              text: f['label'] as String,
              variant: TextVariant.smallMedium,
            ),
          ],
        );
      }).toList(),
    );
  }
}
