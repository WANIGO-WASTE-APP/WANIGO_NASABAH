import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_search_screen.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class SelectBankScreen extends StatelessWidget {
  const SelectBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteBankController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlobalAppBar(
        enableShadow: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GlobalHeader(
                title: 'Bank Sampah Saya',
                subtitle: 'Pilih bank sampah tujuan untuk jadwal setoran Anda.',
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(controller.errorMessage.value),
                    ),
                  );
                }

                if (controller.wasteBankList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: GlobalEmptyState(
                      iconPath: 'assets/icons/waste_bank_icon.svg',
                      title: 'Tidak Terdaftar di Bank Sampah',
                      description:
                          'Anda belum terdaftar di bank sampah manapun. Silakan daftar terlebih dahulu.',
                      buttonText: 'Cari Bank Sampah',
                      onButtonPressed: () {
                        Get.to(() => const WasteBankSearchScreen());
                      },
                    ),
                  );
                }

                return Column(
                  children: controller.wasteBankList
                      .map((wasteBank) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: WasteBankCard(
                              wasteBank: wasteBank,
                              onTap: () {
                                Get.back(result: wasteBank);
                              },
                            ),
                          ))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
