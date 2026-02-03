import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteItemCard extends StatelessWidget {
  final WasteCatalogItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onInfoButtonTap;

  const WasteItemCard({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onTap,
    required this.onInfoButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue100 : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.blue600 : const Color(0xFFCACACA),
            width: isSelected ? 1.5.w : 0.3.w,
          ),
          boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Image
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: item.gambarUrl.isNotEmpty
                        ? Image.network(
                            item.gambarUrl,
                            height: 120.w,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
                // Info Button
                Positioned(
                  top: 18.h,
                  right: 18.w,
                  child: GestureDetector(
                    onTap: onInfoButtonTap,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.blue100 : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFCACACA), width: 0.58.w),
                      ),
                      padding: EdgeInsets.all(6.r),
                      child: SvgPicture.asset(
                        'assets/icons/black_information_icon.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.r, right: 12.r, bottom: 12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    text: item.namaItemSampah,
                    variant: TextVariant.smallBold,
                    color: isSelected ? AppColors.blue800 : AppColors.gray600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  GlobalText(
                    text: '${item.formattedHargaPerKg}/kg',
                    variant: TextVariant.smallMedium,
                    color: isSelected ? AppColors.blue500 : AppColors.gray500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 156.w,
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.gray400,
          size: 48.r,
        ),
      ),
    );
  }
}
