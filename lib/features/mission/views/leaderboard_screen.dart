import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import '../controllers/leaderboard_controller.dart';
import '../widgets/leaderboard_toggle.dart';
import '../widgets/leaderboard_podium.dart';
import '../widgets/leaderboard_ranking_widgets.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LeaderboardController());

    return Scaffold(
      appBar: const GlobalAppBar(),
      body: Stack(
        children: [
          _background(),
          const SafeArea(
            child: Column(
              children: [
                SizedBox(height: 28),
                LeaderboardToggle(),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.45 - 20,
            left: 0,
            right: 0,
            child: const LeaderboardPodium(),
          ),
          const LeaderboardRankingList(),
        ],
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF009CFF),
            Color(0xFF004DFF),
          ],
        ),
      ),
    );
  }
}
