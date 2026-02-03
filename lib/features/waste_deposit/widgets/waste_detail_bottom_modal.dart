import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_waste_detail_controller.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteDetailBottomModal extends StatelessWidget {
  final WasteCatalogItem item;
  final bool isSelected;
  final VoidCallback onSelect;

  const WasteDetailBottomModal({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepositWasteDetailController(itemId: item.id));

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(16.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Obx(() {
        final displayItem = controller.itemDetail.value ?? item;
        final isLoading = controller.isLoading.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 61.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(25.46.r),
              child: displayItem.gambarUrl.isNotEmpty
                  ? Image.network(
                      displayItem.gambarUrl,
                      height: 281.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            SizedBox(height: 16.h),
            Center(
              child: GlobalText(
                text: displayItem.namaItemSampah,
                variant: TextVariant.h4,
                color: AppColors.gray600,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: GlobalText(
                text: displayItem.formattedHargaPerKg + ' tiap kilogram',
                variant: TextVariant.mediumMedium,
                color: AppColors.gray600,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 36.h),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlobalText(
                            text: 'Deskripsi',
                            variant: TextVariant.h6,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 12.h),
                          GlobalText(
                            text: displayItem.deskripsiItemSampah.isNotEmpty
                                ? displayItem.deskripsiItemSampah
                                : 'Deskripsi belum tersedia.',
                            variant: TextVariant.smallRegular,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 24.h),
                          GlobalText(
                            text: 'Cara Pemilahan',
                            variant: TextVariant.h6,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 12.h),
                          GlobalText(
                            text: (displayItem.caraPemilahan != null &&
                                    displayItem.caraPemilahan!.isNotEmpty)
                                ? displayItem.caraPemilahan!
                                : 'Informasi pemilahan belum tersedia.',
                            variant: TextVariant.smallRegular,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 24.h),
                          GlobalText(
                            text: 'Cara Pengemasan',
                            variant: TextVariant.h6,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 12.h),
                          GlobalText(
                            text: (displayItem.caraPengemasan != null &&
                                    displayItem.caraPengemasan!.isNotEmpty)
                                ? displayItem.caraPengemasan!
                                : 'Informasi pengemasan belum tersedia.',
                            variant: TextVariant.smallRegular,
                            color: AppColors.gray600,
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 281.h,
      width: double.infinity,
      color: AppColors.gray100,
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
