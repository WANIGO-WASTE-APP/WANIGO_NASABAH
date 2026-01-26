import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteSubCategorySelector extends StatelessWidget {
  const WasteSubCategorySelector({
    super.key,
    required this.subCategories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<WasteSubCategory> subCategories;
  final int? selectedIndex;
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(
          subCategories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildItem(
              title: subCategories[index].namaSubKategori,
              isActive: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 21.r),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue800 : const Color(0xFFF6F8FA),
          borderRadius: BorderRadius.circular(6.r),
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
}
