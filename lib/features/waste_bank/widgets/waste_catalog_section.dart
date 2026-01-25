import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteCatalogSection extends StatefulWidget {
  const WasteCatalogSection({super.key});

  @override
  State<WasteCatalogSection> createState() => _WasteCatalogSectionState();
}

class _WasteCatalogSectionState extends State<WasteCatalogSection> {
  final RxInt subTabIndex = 0.obs;

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
        _buildCatalogTable(),
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
                onTap: () => subTabIndex.value = 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSubTabItem(
                title: 'Sampah Basah',
                isActive: subTabIndex.value == 1,
                onTap: () => subTabIndex.value = 1,
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

  Widget _buildCatalogTable() {
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
            _buildTableBody(),
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

  Widget _buildTableBody() {
    // Dummy data
    final items = List.generate(7, (index) => 'Nama Item Sampah');

    return Column(
      children: items.map((item) => _buildTableRow(item)).toList(),
    );
  }

  Widget _buildTableRow(String name) {
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
              text: name,
              variant: TextVariant.smallMedium,
              color: const Color(0xFF404040),
            ),
          ),
          Expanded(
            child: GlobalText(
              text: 'Rp.99.999',
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
