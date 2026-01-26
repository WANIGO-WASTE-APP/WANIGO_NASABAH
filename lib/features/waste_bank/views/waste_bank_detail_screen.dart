import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_detail_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_search_controller.dart';
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
    controller.fetchWasteBankDetail(widget.wasteBank.id,
        initialData: widget.wasteBank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        onBackPressed: () {
          try {
            final searchController = Get.find<WasteBankSearchController>();
            searchController.fetchAvailableWasteBanks();
          } catch (e) {}
          Get.back();
        },
      ),
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
                          text: '${wasteBank.tonaseCount ?? 0} ton sampah',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GlobalTabMenu(
                tabs: const ['Informasi Umum', 'Katalog Sampah'],
                initialIndex: controller.selectedTabIndex.value,
                onTabSelected: (index) => controller.changeTab(index),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  return WasteInfoSection(wasteBank: wasteBank);
                } else {
                  return const WasteCatalogSection();
                }
              }),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final wasteBank = controller.wasteBankDetail.value ?? widget.wasteBank;
        final bool isRegistered = wasteBank.isVerified;

        return GlobalBottomActionButton(
          buttonText:
              isRegistered ? 'Buat Setoran Sampah' : 'Gabung Jadi Nasabah',
          onPressed: () {
            if (isRegistered) {
              Get.snackbar(
                  'Info', 'Fitur Buat Setoran Sampah akan segera hadir');
            } else {
              controller.registerAsMember(wasteBank.id);
            }
          },
        );
      }),
    );
  }
}
