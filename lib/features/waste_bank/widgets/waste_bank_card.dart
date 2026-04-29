import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/core/services/location_service.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteBankCard extends StatefulWidget {
  final WasteBankModel wasteBank;
  final VoidCallback? onTap;

  const WasteBankCard({
    Key? key,
    required this.wasteBank,
    this.onTap,
  }) : super(key: key);

  @override
  State<WasteBankCard> createState() => _WasteBankCardState();
}

class _WasteBankCardState extends State<WasteBankCard> {
  final LocationService _locationService = LocationService();
  String? _formattedDistance;

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<void> _calculateDistance() async {
    final currentPosition = await _locationService.getCurrentPosition();
    if (currentPosition != null && mounted) {
      final distance = _locationService.calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        widget.wasteBank.latitude,
        widget.wasteBank.longitude,
      );
      final formatted = _locationService.formatDistance(distance);
      setState(() {
        _formattedDistance = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                      text: widget.wasteBank.name,
                      variant: TextVariant.h6,
                      color: Colors.black),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (_formattedDistance != null) ...[
                        GlobalText(
                            text: '$_formattedDistance dari lokasimu',
                            variant: TextVariant.smallSemiBold,
                            color: AppColors.gray600),
                        const SizedBox(width: 8),
                      ],
                      GlobalText(
                          text: widget.wasteBank.isActive
                              ? 'Aktif'
                              : 'Tidak Aktif',
                          variant: TextVariant.smallBold,
                          color: widget.wasteBank.isActive
                              ? AppColors.green600
                              : AppColors.red600),
                      if (widget.wasteBank.isActive &&
                          widget.wasteBank.depositHour != null) ...[
                        const SizedBox(width: 8),
                        GlobalText(
                          text: widget.wasteBank.depositHour!,
                          variant: TextVariant.xSmallSemiBold,
                          color: AppColors.gray600,
                        ),
                      ],
                      if (widget.wasteBank.openTime != null &&
                          widget.wasteBank.closeTime != null) ...[
                        const SizedBox(width: 8),
                        GlobalText(
                          text: widget.wasteBank.openTime!.format(context),
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
                          text: widget.wasteBank.closeTime!.format(context),
                          variant: TextVariant.smallSemiBold,
                          color: AppColors.gray600,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  GlobalText(
                      text: widget.wasteBank.address,
                      variant: TextVariant.smallMedium,
                      color: AppColors.gray600),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalText(
                                text: widget.wasteBank.description,
                                variant: TextVariant.xSmallMedium,
                                color: AppColors.gray600,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            if ((widget.wasteBank.insight ?? '')
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(height: 4),
                              GlobalText(
                                text:
                                    'Hanya menerima sampah ${widget.wasteBank.insight}',
                                variant: TextVariant.xSmallMedium,
                                color: AppColors.gray600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.wasteBank.isVerified
                              ? AppColors.blue200
                              : AppColors.red200,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: widget.wasteBank.isVerified
                                  ? AppColors.blue600
                                  : AppColors.red600,
                              width: 1),
                        ),
                        child: Center(
                          child: GlobalText(
                            text: widget.wasteBank.isVerified
                                ? 'Sudah Terdaftar'
                                : 'Tidak Terdaftar',
                            variant: TextVariant.smallSemiBold,
                            color: widget.wasteBank.isVerified
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
