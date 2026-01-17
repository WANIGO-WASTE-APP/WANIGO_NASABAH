import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/features/home/controllers/home_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final List<Map<String, dynamic>> items = [
      {
        'icon': 'assets/images/home_icon.svg',
        'activeIcon': 'assets/images/home_active_icon.svg',
        'label': 'Beranda',
        'fallbackIcon': Icons.home,
      },
      {
        'icon': 'assets/images/history_icon.svg',
        'activeIcon': 'assets/images/history_active_icon.svg',
        'label': 'Riwayat',
        'fallbackIcon': Icons.history,
      },
      {
        'icon': 'assets/images/message_icon.svg',
        'activeIcon': 'assets/images/message_active_icon.svg',
        'label': 'Pesan',
        'fallbackIcon': Icons.chat_bubble_outline,
      },
      {
        'icon': 'assets/images/profile_icon.svg',
        'activeIcon': 'assets/images/profile_active_icon.svg',
        'label': 'Profil',
        'fallbackIcon': Icons.person,
      },
    ];

    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFCACACA),
            ),
            BottomAppBar(
              color: Colors.white,
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.r,
              child: SizedBox(
                height: 60.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      item: items[0],
                      index: 0,
                      isActive: controller.currentIndex.value == 0,
                      onTap: () => controller.onBottomNavTapped(0),
                    ),
                    _buildNavItem(
                      context: context,
                      item: items[1],
                      index: 1,
                      isActive: controller.currentIndex.value == 1,
                      onTap: () => controller.onBottomNavTapped(1),
                    ),
                    SizedBox(width: 56.r), // Placeholder for FAB
                    _buildNavItem(
                      context: context,
                      item: items[2], // Pesan (Index 3 logic in controller)
                      index: 3,
                      isActive: controller.currentIndex.value == 3,
                      onTap: () => controller.onBottomNavTapped(3),
                    ),
                    _buildNavItem(
                      context: context,
                      item: items[3], // Profil (Index 4 logic in controller)
                      index: 4,
                      isActive: controller.currentIndex.value == 4,
                      onTap: () => controller.onBottomNavTapped(4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildNavItem({
    required BuildContext context,
    required Map<String, dynamic> item,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.blue600 : AppColors.gray900;
    final iconPath = isActive ? item['activeIcon'] : item['icon'];

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.r,
              height: 24.r,
              placeholderBuilder: (BuildContext context) {
                return SizedBox(width: 24.r, height: 24.r);
              },
            ),
            SizedBox(height: 4.h),
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 12.sp,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
