import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/features/mission/views/leaderboard_screen.dart';
import 'package:wanigo_nasabah/features/mission/widgets/mission_card.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            GlobalHeader(
                title: 'Misi WANIGO!',
                subtitle: 'Selesaikan tantangan, dapatkan poin tambahan!'),
            SizedBox(height: 16.h),
            MissionCard(),
          ],
        ),
      ),
      bottomNavigationBar: GlobalBottomActionButton(
        text: 'Lihat Papan Peringkat',
        onPressed: () {
          Get.to(() => const LeaderboardScreen());
        },
      ),
    );
  }
}
