import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class DepositInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  final MainAxisAlignment mainAxisAlignment;

  const DepositInfoItem({
    Key? key,
    required this.label,
    required this.value,
    this.valueWidget,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            GlobalText(
              text: label,
              variant: TextVariant.smallBold,
              color: AppColors.gray600,
            ),
            SizedBox(width: 12.r),
            if (valueWidget != null)
              valueWidget!
            else
              Expanded(
                child: GlobalText(
                  text: value,
                  variant: TextVariant.smallBold,
                  color: AppColors.gray600,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
