import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_detail_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/widgets.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class WasteBankDetailScreen extends StatefulWidget {
  final WasteBankModel wasteBank;

  const WasteBankDetailScreen({
    super.key,
    required this.wasteBank,
  });

  @override
  State<WasteBankDetailScreen> createState() => _WasteBankDetailScreenState();
}

class _WasteBankDetailScreenState extends State<WasteBankDetailScreen> {
  final controller = Get.put(WasteBankDetailController());

  @override
  void initState() {
    super.initState();
    controller.fetchWasteBankDetail(widget.wasteBank.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final wasteBank = controller.wasteBankDetail.value ?? widget.wasteBank;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/login_ads.png',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlobalText(
                        text: wasteBank.address,
                        variant: TextVariant.xSmallMedium,
                        color: AppColors.gray600),
                    const SizedBox(height: 8),
                    GlobalText(
                        text: wasteBank.name,
                        variant: TextVariant.h5,
                        color: AppColors.gray700),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StatusTag(isActive: wasteBank.isActive),
                        const SizedBox(width: 8),
                        DetailInfoBadge(
                          iconPath: 'assets/icons/nasabah_icon.svg',
                          text: '${wasteBank.nasabahCount ?? 0} nasabah',
                        ),
                        const SizedBox(width: 8),
                        DetailInfoBadge(
                          iconPath: 'assets/icons/tonne_icon.svg',
                          text: '${wasteBank.nasabahCount ?? 0} nasabah',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlobalTabMenu(
                  tabs: ['Informasi Umum', 'Katalog Sampah'],
                  onTabSelected: (tab) {}),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GlobalText(
                      text: 'Tentang Bank Sampah',
                      variant: TextVariant.largeBold,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    GlobalText(
                      text: wasteBank.description,
                      variant: TextVariant.xSmallRegular,
                      color: AppColors.gray500,
                    ),
                    const SizedBox(height: 24),
                    const GlobalText(
                      text: 'Data Kontak Bank Sampah',
                      variant: TextVariant.largeBold,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 12),
                    ContactInfoItem(
                      iconPath: 'assets/icons/phone_icon.svg',
                      text: wasteBank.phone ?? '-',
                    ),
                    const SizedBox(height: 4),
                    ContactInfoItem(
                      iconPath: 'assets/icons/email_icon.svg',
                      text: wasteBank.email ?? '-',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFE9FD),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.blue800,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/information_icon.svg',
                            ),
                            const SizedBox(width: 3),
                            const GlobalText(
                              text: 'Informasi Bank Sampah',
                              variant: TextVariant.xSmallRegular,
                              color: AppColors.blue600,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const ScheduleSectionItem(
                                title: 'Jadwal Operasional',
                                subtitle: 'Senin - Jumat',
                                time: '08.00 - 16.00',
                              ),
                              const SizedBox(width: 16),
                              const ScheduleSectionItem(
                                title: 'Jadwal Setoran Sampah',
                                subtitle: 'Setiap Bulan',
                                time: '10:00',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: GlobalBottomActionButton(
        text: 'Gabung Jadi Nasabah',
        onPressed: () {
          Get.dialog(GlobalModal(
            imagePath: 'assets/icons/success_icon.svg',
            title: 'Berhasil Terdaftar',
            message:
                'Selamat! Anda telah berhasil terdaftar sebagai nasabah bank sampah. Sekarang Anda dapat mulai menyetor sampah',
            primaryButtonText: 'Kembali',
            onPrimaryButtonPressed: () => Get.back(),
          ));
        },
      ),
    );
  }
}
