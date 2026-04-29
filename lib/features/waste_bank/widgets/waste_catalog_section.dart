import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/features/waste_bank/controllers/waste_bank_detail_controller.dart';
import 'package:wanigo_nasabah/widgets/global_empty_state.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteCatalogSection extends StatefulWidget {
  const WasteCatalogSection({super.key});

  @override
  State<WasteCatalogSection> createState() => _WasteCatalogSectionState();
}

class _WasteCatalogSectionState extends State<WasteCatalogSection> {
  final RxInt subTabIndex = 0.obs;
  final WasteBankDetailController controller =
      Get.find<WasteBankDetailController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GlobalText(
            text: 'Daftar Jenis Sampah yang Diterima',
            variant: TextVariant.largeBold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildSubTabSelector(),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isCatalogLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.wasteCatalog.value == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: GlobalText(
                  text:
                      'Daftar Sebagai Nasabah Bank sampah ini terlebih dahulu untuk melihat katalog sampah.',
                  variant: TextVariant.smallMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final catalogItems = controller.wasteCatalog.value!.katalogSampah;

          if (catalogItems.isEmpty) {
            final categoryName =
                subTabIndex.value == 0 ? 'sampah kering' : 'sampah basah';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: GlobalEmptyState(
                iconPath: 'assets/icons/catalog_empty_icon.svg',
                title: 'Katalog Masih Kosong',
                description:
                    'Bank sampah ini belum menerima setoran $categoryName. Coba cari bank sampah lain yang bisa menampung ${categoryName}mu.',
              ),
            );
          }

          return _buildCatalogTable(catalogItems);
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildSubTabItem(
                title: 'Sampah Kering',
                isActive: subTabIndex.value == 0,
                onTap: () {
                  subTabIndex.value = 0;
                  if (controller.wasteBankDetail.value != null) {
                    controller.fetchWasteCatalog(
                        controller.wasteBankDetail.value!.id, 'kering');
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSubTabItem(
                title: 'Sampah Basah',
                isActive: subTabIndex.value == 1,
                onTap: () {
                  subTabIndex.value = 1;
                  if (controller.wasteBankDetail.value != null) {
                    controller.fetchWasteCatalog(
                        controller.wasteBankDetail.value!.id, 'basah');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabItem({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue800 : const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: GlobalText(
          text: title,
          variant: TextVariant.smallBold,
          color: isActive ? Colors.white : AppColors.gray500,
        ),
      ),
    );
  }

  Widget _buildCatalogTable(List<WasteCatalogItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFFEFEFEF)),
            right: BorderSide(color: Color(0xFFEFEFEF)),
            bottom: BorderSide(color: Color(0xFFEFEFEF)),
          ),
        ),
        child: Column(
          children: [
            _buildTableHeader(),
            _buildTableBody(items),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEFEFEF),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GlobalText(
                  text: 'Nama',
                  variant: TextVariant.mediumBold,
                  color: AppColors.gray600,
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/arrow_down_arrow_up_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: GlobalText(
                    text: 'Harga Item/Kg',
                    variant: TextVariant.mediumBold,
                    color: AppColors.gray700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/arrow_down_arrow_up_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody(List<WasteCatalogItem> items) {
    return Column(
      children: items.map((item) => _buildTableRow(item)).toList(),
    );
  }

  Widget _buildTableRow(WasteCatalogItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF2F2F2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GlobalText(
              text: item.namaItemSampah,
              variant: TextVariant.smallMedium,
              color: const Color(0xFF404040),
            ),
          ),
          Expanded(
            child: GlobalText(
              text: item.formattedHargaPerKg,
              variant: TextVariant.smallMedium,
              color: const Color(0xFF404040),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
