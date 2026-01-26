import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_controller.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_search_screen.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/waste_bank_card.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/widgets/global_bottom_action_button.dart';
import 'package:wanigo_nasabah/widgets/global_header.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_nasabah/features/waste_bank/views/waste_bank_detail_screen.dart';

class WasteBankScreen extends StatelessWidget {
  const WasteBankScreen({Key? key}) : super(key: key);

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GlobalHeader(
                    title: 'Bank Sampah Saya',
                    subtitle:
                        'Menampilkan daftar bank sampah yang terdaftar sebagai tempat Anda menabung sampah.'),
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
                        title: 'Tidak Terdaftar di Bank Sampah Manapun',
                        description:
                            'Saat ini, kamu belum terdaftar sebagai nasabah di bank sampah manapun. Yuk, daftarkan dirimu di bank sampah terdekat untuk mulai menabung dan mengelola sampah dengan mudah!',
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
                                  Get.to(() => WasteBankDetailScreen(
                                      wasteBank: wasteBank));
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
      ),
      bottomNavigationBar: Obx(
        () => controller.wasteBankList.isNotEmpty
            ? GlobalBottomActionButton(
                buttonText: 'Tambah Bank Sampah Baru',
                onPressed: () {
                  Get.to(() => const WasteBankSearchScreen());
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
