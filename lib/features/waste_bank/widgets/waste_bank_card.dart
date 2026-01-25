import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteBankCard extends StatelessWidget {
  final WasteBankModel wasteBank;
  final VoidCallback? onTap;

  const WasteBankCard({
    Key? key,
    required this.wasteBank,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                      text: wasteBank.name,
                      variant: TextVariant.h6,
                      color: Colors.black),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (wasteBank.distance != null) ...[
                        GlobalText(
                            text: '${wasteBank.distance}km dari lokasimu',
                            variant: TextVariant.smallSemiBold,
                            color: AppColors.gray600),
                        const SizedBox(width: 24),
                      ],
                      GlobalText(
                          text: wasteBank.isActive ? 'Aktif' : 'Tidak Aktif',
                          variant: TextVariant.smallBold,
                          color: wasteBank.isActive
                              ? AppColors.green600
                              : AppColors.red600),
                      if (wasteBank.openTime != null &&
                          wasteBank.closeTime != null) ...[
                        const SizedBox(width: 8),
                        GlobalText(
                          text: wasteBank.openTime!.format(context),
                          variant: TextVariant.smallSemiBold,
                          color: AppColors.gray600,
                        ),
                        const SizedBox(width: 4),
                        GlobalText(
                          text: '-',
                          variant: TextVariant.smallSemiBold,
                          color: AppColors.gray600,
                        ),
                        const SizedBox(width: 4),
                        GlobalText(
                          text: wasteBank.closeTime!.format(context),
                          variant: TextVariant.smallSemiBold,
                          color: AppColors.gray600,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  GlobalText(
                      text: wasteBank.address,
                      variant: TextVariant.smallMedium,
                      color: AppColors.gray600),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GlobalText(
                            text: wasteBank.description,
                            variant: TextVariant.xSmallMedium,
                            color: AppColors.gray600,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: wasteBank.isVerified
                              ? AppColors.blue200
                              : AppColors.red200,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: wasteBank.isVerified
                                  ? AppColors.blue600
                                  : AppColors.red600,
                              width: 1),
                        ),
                        child: Center(
                          child: GlobalText(
                            text: wasteBank.isVerified
                                ? 'Sudah Terdaftar'
                                : 'Tidak Terdaftar',
                            variant: TextVariant.smallSemiBold,
                            color: wasteBank.isVerified
                                ? AppColors.blue600
                                : AppColors.red600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
