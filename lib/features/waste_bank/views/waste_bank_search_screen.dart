import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_search_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class WasteBankSearchScreen extends StatelessWidget {
  const WasteBankSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteBankSearchController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(
        enableShadow: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 8),
                              child: SvgPicture.asset(
                                'assets/icons/search_icon.svg',
                                width: 19,
                                height: 19,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                onChanged: controller.searchWasteBanks,
                                decoration: const InputDecoration(
                                  hintText: 'Ketikkan nama bank sampah disini',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.gray200,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/maps_icon.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: GlobalText(
                          text: 'Terdekat',
                          variant: TextVariant.smallMedium,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: GlobalText(
                            text: 'Sampah Basah',
                            variant: TextVariant.smallMedium,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: GlobalText(
                            text: 'Sampah Kering',
                            variant: TextVariant.smallMedium,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() => GlobalText(
                      text:
                          'Menampilkan ${controller.filteredWasteBanks.length} Bank Sampah',
                      variant: TextVariant.mediumSemiBold,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFC4C4C4),
            height: 1,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredWasteBanks.isEmpty) {
                return const Center(
                  child: GlobalText(
                    text: 'Tidak ada mitra bank sampah ditemukan',
                    variant: TextVariant.mediumMedium,
                    color: AppColors.gray600,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredWasteBanks.length,
                itemBuilder: (context, index) {
                  final wasteBank = controller.filteredWasteBanks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: WasteBankCard(wasteBank: wasteBank),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
