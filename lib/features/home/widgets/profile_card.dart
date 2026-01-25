import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_screen.dart';
import 'package:wanigo_nasabah/widgets/global_divider.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/profile_model.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFCACACA), width: 1),
        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 7.h),
          GlobalDivider(),
          SizedBox(height: 7.h),
          _buildNasabahInfo(),
          SizedBox(height: 7.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(context),
        SizedBox(width: 10.w),
        _buildGreeting(),
        _buildPointsBadge(context),
      ],
    );
  }

  Widget _buildNasabahInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                text: profile.bankSampahName.isNotEmpty
                    ? 'Nasabah ${profile.bankSampahName}'
                    : 'Daftar Sebagai Nasabah Bank Sampah',
                variant: TextVariant.smallSemiBold,
                color: Colors.black,
              ),
              if (profile.bankSampahName.isNotEmpty) ...[
                SizedBox(height: 2.h),
                GlobalText(
                  text: profile.address,
                  variant: TextVariant.xSmallMedium,
                  color: AppColors.gray600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/arrow_circle_right.svg',
                width: 32.r,
                height: 32.r,
              ),
              onTap: () {
                Get.to(() => const WasteBankScreen());
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child:
          profile.profilePhotoUrl != null && profile.profilePhotoUrl!.isNotEmpty
              ? Image.network(
                  profile.profilePhotoUrl!,
                  width: 40.r,
                  height: 40.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar();
                  },
                )
              : _buildDefaultAvatar(),
    );
  }

  Widget _buildDefaultAvatar() {
    return Image.asset(
      'assets/images/default-img.jpg',
      width: 40.r,
      height: 40.r,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading default-img.jpg: $error');
        return Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(
            Icons.person,
            size: 30.r,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }

  Widget _buildGreeting() {
    return Expanded(
      child: Row(
        children: [
          GlobalText(
            text: 'Hai, ',
            variant: TextVariant.largeMedium,
            color: Colors.black,
          ),
          Flexible(
            child: GlobalText(
              text: profile.userName,
              variant: TextVariant.h6,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.blue700, width: 0.6),
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFE0EBFF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/point_icon.svg',
            width: 22.r,
            height: 22.r,
          ),
          SizedBox(width: 4.w),
          GlobalText(
            text: '${profile.points} POIN',
            variant: TextVariant.smallBold,
            color: AppColors.blue800,
          ),
        ],
      ),
    );
  }
}
