import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WithdrawalMethodDropdown extends StatefulWidget {
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String hint;

  const WithdrawalMethodDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.hint = 'Pilih Metode Penarikan Saldo',
  });

  @override
  State<WithdrawalMethodDropdown> createState() =>
      _WithdrawalMethodDropdownState();
}

class _WithdrawalMethodDropdownState extends State<WithdrawalMethodDropdown> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return PopupMenuButton<String>(
        onOpened: () => setState(() => _isOpened = true),
        onSelected: (value) {
          setState(() => _isOpened = false);
          widget.onChanged(value);
        },
        onCanceled: () => setState(() => _isOpened = false),
        offset: Offset(0, 52.h),
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: const BorderSide(color: Color(0XFFCACACA)),
        ),
        color: Colors.white,
        itemBuilder: (context) {
          return widget.items.map((item) {
            final isSelected = widget.value == item;
            return PopupMenuItem<String>(
              value: item,
              padding: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0XFFF6F8FA) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalText(
                      text: item,
                      variant: TextVariant.mediumRegular,
                      color: AppColors.gray900,
                    ),
                    if (isSelected)
                      SvgPicture.asset(
                        'assets/icons/success_black_icon.svg',
                        width: 10.r,
                        height: 10.r,
                      ),
                  ],
                ),
              ),
            );
          }).toList();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: _isOpened ? AppColors.blue600 : const Color(0XFFCACACA)),
            boxShadow: GlobalShadow.getShadow(ShadowVariant.large),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalText(
                text: widget.value ?? widget.hint,
                variant: TextVariant.mediumMedium,
                color: AppColors.gray900,
              ),
              SvgPicture.asset(
                _isOpened
                    ? 'assets/icons/schedule_arrow_up_icon.svg'
                    : 'assets/icons/schedule_arrow_down_icon.svg',
                width: 20.w,
                height: 20.h,
                colorFilter:
                    const ColorFilter.mode(AppColors.gray500, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      );
    });
  }
}
