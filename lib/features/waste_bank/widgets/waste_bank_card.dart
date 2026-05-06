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
    print(
        'DEBUG - WasteBankCard: Starting distance calculation for ${widget.wasteBank.name}');

    final currentPosition = await _locationService.getCurrentPosition();
    print('DEBUG - WasteBankCard: Current position: $currentPosition');

    if (currentPosition != null && mounted) {
      final distance = _locationService.calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        widget.wasteBank.latitude,
        widget.wasteBank.longitude,
      );
      print('DEBUG - WasteBankCard: Distance calculated: $distance meters');
      final formatted = _locationService.formatDistance(distance);
      setState(() {
        _formattedDistance = formatted;
      });
    } else {
      print(
          'DEBUG - WasteBankCard: Cannot get position - permission denied or service disabled');
      if (mounted) {
        setState(() {
          _formattedDistance = null;
        });
      }
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
                      GlobalText(
                          text: _formattedDistance != null
                              ? '$_formattedDistance dari lokasimu'
                              : 'null',
                          variant: TextVariant.smallSemiBold,
                          color: AppColors.gray600),
                      const SizedBox(width: 8),
                      GlobalText(
                          text: widget.wasteBank.isActive
                              ? 'Aktif'
                              : 'Tidak Aktif',
                          variant: TextVariant.smallBold,
                          color: widget.wasteBank.isActive
                              ? AppColors.green600
                              : AppColors.red600),
                      const SizedBox(width: 8),
                      GlobalText(
                        text: widget.wasteBank.openTime != null
                            ? widget.wasteBank.openTime!.format(context)
                            : 'null',
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
                        text: widget.wasteBank.closeTime != null
                            ? widget.wasteBank.closeTime!.format(context)
                            : 'null',
                        variant: TextVariant.smallSemiBold,
                        color: AppColors.gray600,
                      ),
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
                              text:
                                  'Hanya menerima sampah ${widget.wasteBank.insight ?? 'null'}',
                              variant: TextVariant.xSmallMedium,
                              color: AppColors.gray600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
