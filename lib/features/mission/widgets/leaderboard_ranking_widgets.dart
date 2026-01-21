import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class LeaderboardRankingList extends StatelessWidget {
  const LeaderboardRankingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(36),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const RankingListItem(
                          rank: 0); // Replace with real logic
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Title
          Positioned(
            top: -12, // Float above the container
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFCACACA),
                    width: 0.65,
                  ),
                  borderRadius: BorderRadius.circular(58),
                  boxShadow: GlobalShadow.getShadow(ShadowVariant.large),
                ),
                child: GlobalText(
                  text: 'Papan Peringk🔥t',
                  variant: TextVariant.h4,
                  color: AppColors.blue600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RankingListItem extends StatelessWidget {
  final int rank;
  const RankingListItem({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    final displayRank = rank == 0 ? 1 : rank; // Dummy for now
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCACACA), width: 1),
        boxShadow: GlobalShadow.getShadow(ShadowVariant.large),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.blue600,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: GlobalText(
                text: '$displayRank',
                color: Colors.white,
                variant: TextVariant.largeMedium,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/default-img.jpg',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: GlobalText(
              text: 'Lidya Putri',
              variant: TextVariant.largeSemiBold,
              color: AppColors.gray600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.blue100,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/point_icon.svg',
                  width: 28,
                  height: 28,
                ),
                const SizedBox(height: 4),
                GlobalText(
                  text: '12.000',
                  variant: TextVariant.smallExtraBold,
                  color: AppColors.blue600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
