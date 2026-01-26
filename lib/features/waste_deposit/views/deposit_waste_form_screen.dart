import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_deposit/controllers/deposit_waste_form_controller.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';
import 'package:wanigo_nasabah/features/waste_deposit/widgets/waste_sub_category_selector.dart';
import 'package:wanigo_nasabah/features/waste_deposit/widgets/waste_item_card.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class DepositWasteFormScreen extends StatelessWidget {
  const DepositWasteFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DepositWasteFormController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalHeader(
                    title: 'Form Pengajuan Setoran',
                    subtitle:
                        'Untuk Jadwal Setoran di ${DateFormatter.formatFullDate(DateTime.now())}',
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    final wasteBank = controller.wasteBank.value;
                    if (wasteBank == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0XFFCACACA)),
                        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GlobalText(
                                  text: wasteBank.name,
                                  variant: TextVariant.smallSemiBold,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 4.h),
                                GlobalText(
                                  text: wasteBank.address,
                                  variant: TextVariant.smallMedium,
                                  color: AppColors.gray600,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SvgPicture.asset(
                            'assets/icons/arrow_circle_right.svg',
                            width: 32.r,
                            height: 32.r,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Obx(() => GlobalTabMenu(
                  tabs: const ['Sampah Kering', 'Sampah Basah'],
                  initialIndex: controller.selectedTabIndex.value,
                  onTabSelected: (index) => controller.changeTab(index),
                )),
            SizedBox(height: 16.h),
            Obx(() {
              final isKering = controller.selectedTabIndex.value == 0;
              final categoryName = isKering ? 'kering' : 'basah';

              if (controller.isSubCategoryLoading.value ||
                  controller.isWasteItemsLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.subCategories.isEmpty ||
                  controller.allWasteItems.isEmpty) {
                return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 80.h),
                    child: GlobalEmptyState(
                        iconPath: 'assets/icons/catalog_empty_icon.svg',
                        iconSize: 150,
                        title: 'Katalog Masih Kosong',
                        description:
                            'Bank sampah ini belum menerima setoran sampah $categoryName. Coba cari bank sampah lain yang bisa menampung sampah $categoryName-mu.'));
              }

              return Column(
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: 48.h),
                    child: WasteSubCategorySelector(
                      subCategories: controller.subCategories,
                      selectedIndex: controller.selectedSubCategoryIndex.value,
                      onSelected: (index) =>
                          controller.selectSubCategory(index),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 156 / 220,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                      ),
                      itemCount: controller.displayedWasteItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.displayedWasteItems[index];
                        return Obx(() => WasteItemCard(
                              item: item,
                              isSelected: controller.selectedWasteItemIds
                                  .contains(item.id),
                              onTap: () => controller.selectWasteItem(item.id),
                            ));
                      },
                    ),
                  ),
                  SizedBox(height: 48.h),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.selectedWasteItemIds.isEmpty) {
          return const SizedBox.shrink();
        }
        return GlobalBottomActionButton(
          text:
              'Total ${controller.selectedWasteItemIds.length} Item Sampah Dipilih',
          buttonText: 'Simpan Laporan',
          isLoading: controller.isSubmitting.value,
          onPressed: controller.submitForm,
        );
      }),
    );
  }
}
