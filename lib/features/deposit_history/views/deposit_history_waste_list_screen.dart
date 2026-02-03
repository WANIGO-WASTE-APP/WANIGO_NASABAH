import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_waste_list_controller.dart';
import 'package:wanigo_nasabah/data/models/waste_deposit_item_detail_model.dart';
import 'package:wanigo_nasabah/core/utils/currency_formatter.dart';
import 'package:wanigo_nasabah/core/utils/date_formatter.dart';

class DepositHistoryWasteListScreen
    extends GetView<DepositHistoryWasteListController> {
  const DepositHistoryWasteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DepositHistoryWasteListController>()) {
      Get.put(DepositHistoryWasteListController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: Obx(() {
        final deposit = controller.deposit.value;

        if (controller.isLoading.value && controller.wasteItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GlobalHeader(
                    title: 'Daftar Item Sampah',
                    subtitle:
                        'Untuk Jadwal Pemilahan di ${DateFormatter.formatStringDate(deposit?.updatedAt ?? deposit?.createdAt)}',
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: controller.isEditMode.value
                            ? null
                            : controller.toggleEditMode,
                        child: GlobalText(
                          text: controller.isEditMode.value
                              ? 'Hapus Semua'
                              : 'Edit Daftar Item Sampah',
                          variant: TextVariant.smallBold,
                          color: AppColors.blue600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                if (controller.wasteItems.isEmpty &&
                    !controller.isLoading.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: GlobalText(
                        text: 'Tidak ada item sampah',
                        variant: TextVariant.mediumBold,
                      ),
                    ),
                  )
                else
                  ...controller.wasteItems
                      .map((item) => _buildWasteItemList(item)),
                if (controller.isEditMode.value)
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: GlobalButton(
                        variant: ButtonVariant.medium,
                        style: ButtonStyle.subtle,
                        text: 'Tambah Item Baru',
                        onPressed: () {}),
                  )
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!controller.isEditMode.value) return const SizedBox.shrink();
        return GlobalBottomActionButton(
          buttonText: 'Simpan',
          onPressed: controller.toggleEditMode,
          showArrow: true,
          text: 'Total ${controller.wasteItems.length} item sampah Dipilih',
          onArrowPressed: () {},
        );
      }),
    );
  }

  Widget _buildWasteItemList(WasteDepositItemDetailModel item) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildItemImage(item.gambarUrl),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                      text: item.nama,
                      variant: TextVariant.mediumBold,
                      color: AppColors.gray600,
                    ),
                    SizedBox(height: 4.h),
                    GlobalText(
                      text: '${CurrencyFormatter.format(item.harga)}/kg',
                      variant: TextVariant.smallSemiBold,
                      color: AppColors.gray600,
                    ),
                  ],
                ),
              ),
              if (controller.isEditMode.value) ...[
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: null,
                  child: SvgPicture.asset(
                    'assets/icons/close_circle_icon.svg',
                    width: 52.r,
                    height: 52.r,
                  ),
                ),
              ],
            ],
          ),
        ),
        Divider(
          color: const Color(0xFFCACACA),
          thickness: 1.h,
        ),
      ],
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.network(
        imageUrl,
        height: 80.h,
        width: 80.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 80.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.gray400,
          size: 32.r,
        ),
      ),
    );
  }
}
