import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;
import 'package:wanigo_nasabah/features/deposit_history/controllers/deposit_history_detail_controller.dart';
import 'package:wanigo_nasabah/features/deposit_history/widgets/deposit_timeline_status.dart';
import 'package:wanigo_nasabah/features/deposit_history/widgets/deposit_info_item.dart';
import 'package:wanigo_nasabah/features/deposit_history/widgets/status_badge.dart';
import 'package:wanigo_nasabah/core/utils/currency_formatter.dart';

class DepositHistoryDetailScreen
    extends GetView<DepositHistoryDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.deposit.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final deposit = controller.deposit.value;
        if (deposit == null) {
          return const Center(
              child: GlobalText(
                  text: 'Data tidak ditemukan',
                  variant: TextVariant.mediumBold));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 4.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlobalHeader(title: 'Detail Setoran Sampah'),
                        SizedBox(height: 24.h),
                        const GlobalText(
                          text: 'Informasi Umum Setoran',
                          variant: TextVariant.mediumBold,
                          color: AppColors.gray600,
                        ),
                        SizedBox(height: 16.h),
                        DepositInfoItem(
                          label: 'Kode Setoran Sampah',
                          value: deposit.kodeSetoranSampah,
                        ),
                        SizedBox(height: 12.h),
                        DepositInfoItem(
                          label: 'Status Setoran',
                          value: deposit.statusSetoran,
                          valueWidget:
                              StatusBadge(status: deposit.statusSetoran),
                        ),
                        SizedBox(height: 12.h),
                        DepositInfoItem(
                          label: 'Nama Bank Sampah',
                          value: deposit.bankSampah?.name ?? '-',
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GlobalText(
                          text: 'Timeline Status Setoran Sampah',
                          variant: TextVariant.mediumBold,
                          color: AppColors.gray600,
                        ),
                        SizedBox(height: 24.h),
                        DepositTimelineStatus(
                          status: controller.statusSetoran.value,
                          date: DateTime.tryParse(deposit.tanggalSetoran) ??
                              DateTime.now(),
                        ),
                        SizedBox(height: 6.h),
                        Divider(color: Color(0xFFCACACA), thickness: 1.h),
                        SizedBox(height: 6.h),
                        InkWell(
                          onTap: controller.toggleNotesExpanded,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const GlobalText(
                                text: 'Catatan Status Setoran:',
                                variant: TextVariant.mediumBold,
                                color: AppColors.gray600,
                              ),
                              Obx(() => AnimatedRotation(
                                    duration: const Duration(milliseconds: 200),
                                    turns: controller.isNotesExpanded.value
                                        ? 0.5
                                        : 0,
                                    child: SvgPicture.asset(
                                      'assets/icons/schedule_arrow_down_icon.svg',
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Obx(() {
                          if (!controller.isNotesExpanded.value) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: GlobalText(
                              text: deposit.catatanStatusSetoran ??
                                  'Belum ada catatan',
                              variant: TextVariant.smallRegular,
                              color: AppColors.gray500,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GlobalText(
                          text: 'Informasi Bank Sampah',
                          variant: TextVariant.mediumBold,
                          color: AppColors.gray600,
                        ),
                        SizedBox(height: 24.h),
                        DepositInfoItem(
                          label: 'Total Item Sampah',
                          value: '${deposit.jumlahItem} item',
                        ),
                        SizedBox(height: 12.h),
                        DepositInfoItem(
                          label: 'Total Berat Sampah',
                          value: deposit.totalBeratFormat,
                        ),
                        SizedBox(height: 12.h),
                        DepositInfoItem(
                          label: 'Total Saldo Didapatkan',
                          value: CurrencyFormatter.format(deposit.totalSaldo),
                        ),
                        SizedBox(height: 12.h),
                        DepositInfoItem(
                          label: 'Kamu mendapatkan',
                          value: '${deposit.totalPoin} POIN',
                          mainAxisAlignment: MainAxisAlignment.start,
                          valueWidget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/point_icon.svg',
                                width: 18.w,
                                height: 18.h,
                              ),
                              SizedBox(width: 4.w),
                              GlobalText(
                                text: '${deposit.totalPoin} POIN',
                                variant: TextVariant.smallBold,
                                color: AppColors.blue800,
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Color(0xFFCACACA), thickness: 1.h),
                        SizedBox(height: 2.h),
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.detailSetoranBySetoran,
                              arguments: deposit,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const GlobalText(
                                text: 'Lihat Rincian Item Setoran Sampah',
                                variant: TextVariant.smallBold,
                                color: AppColors.gray600,
                              ),
                              SvgPicture.asset(
                                'assets/icons/arrow_right_icon.svg',
                                width: 32.w,
                                height: 32.h,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildDivider(),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
      bottomNavigationBar: GlobalBottomActionButton(
        buttonText: 'Perlu Bantuan? Hubungi Petugas',
        onPressed: () {},
      ),
    );
  }
}

Widget _buildDivider() {
  return Container(
    width: double.infinity,
    height: 6.h,
    color: const Color(0xFFF4F4F4),
  );
}
