import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // SVG Podium Background
          SvgPicture.asset(
            'assets/icons/podium_icon.svg',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          // Rank 2
          Positioned(
            left: 30,
            bottom: 90,
            child: _podiumItem(
              'Diva',
              '11k',
            ),
          ),

          // Rank 1
          Positioned(
            bottom: 124,
            child: _podiumItem(
              'Lidya',
              '12k',
            ),
          ),

          // Rank 3
          Positioned(
            right: 30,
            bottom: 80,
            child: _podiumItem(
              'Adit',
              '9k',
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumItem(
    String name,
    String point,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar + Point Badge Stack
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: AssetImage('assets/images/default-img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0026FF),
                      Color(0xFF0038FF),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: GlobalText(
                    text: '$point point',
                    variant: TextVariant.xSmallMedium,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Name Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.blue600,
            borderRadius: BorderRadius.circular(4),
          ),
          child: GlobalText(
            text: name,
            variant: TextVariant.mediumMedium,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
