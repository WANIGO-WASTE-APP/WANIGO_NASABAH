import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/profile_model.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFCACACA), width: 0.6),
        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 7.h),
          const Divider(
            height: 1,
            thickness: 0.6,
            color: Color(0xFFCACACA),
          ),
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
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(
                text: 'Nasabah ${profile.bankSampahName}',
                variant: TextVariant.smallSemiBold,
                color: Colors.black,
              ),
              SizedBox(height: 2.h),
              GlobalText(
                text: profile.address,
                variant: TextVariant.xSmallMedium,
                color: AppColors.gray600,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.blue600,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.blue600,
            size: 16.r,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF073C9D), width: 0.6),
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFE0EBFF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/point_icon.png',
            width: 14.r,
            height: 14.r,
            color: AppColors.blue600,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading point_icon.png: $error');
              return Icon(
                Icons.star,
                size: 14.r,
                color: AppColors.blue600,
              );
            },
          ),
          SizedBox(width: 4.w),
          GlobalText(
            text: '${profile.points} POIN',
            variant: TextVariant.xSmallSemiBold,
            color: AppColors.blue600,
          ),
        ],
      ),
    );
  }
}
