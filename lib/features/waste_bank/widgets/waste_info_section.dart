import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanigo_nasabah/data/models/waste_bank_model.dart';
import 'package:wanigo_nasabah/features/waste_bank/widgets/widgets.dart';
import 'package:wanigo_ui/wanigo_ui.dart';

class WasteInfoSection extends StatelessWidget {
  final WasteBankModel wasteBank;

  const WasteInfoSection({
    super.key,
    required this.wasteBank,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GlobalText(
            text: 'Tentang Bank Sampah',
            variant: TextVariant.largeBold,
            color: Colors.black,
          ),
          const SizedBox(height: 8),
          GlobalText(
            text: wasteBank.description,
            variant: TextVariant.xSmallRegular,
            color: AppColors.gray500,
          ),
          const SizedBox(height: 24),
          const GlobalText(
            text: 'Data Kontak Bank Sampah',
            variant: TextVariant.largeBold,
            color: Colors.black,
          ),
          const SizedBox(height: 12),
          ContactInfoItem(
            iconPath: 'assets/icons/phone_icon.svg',
            text: wasteBank.phone ?? '-',
          ),
          const SizedBox(height: 4),
          ContactInfoItem(
            iconPath: 'assets/icons/email_icon.svg',
            text: wasteBank.email ?? '-',
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFDFE9FD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.blue800,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/information_icon.svg',
                  ),
                  const SizedBox(width: 3),
                  const GlobalText(
                    text: 'Informasi Bank Sampah',
                    variant: TextVariant.xSmallRegular,
                    color: AppColors.blue600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const ScheduleSectionItem(
                      title: 'Jadwal Operasional',
                      subtitle: 'Senin - Jumat',
                      time: '08.00 - 16.00',
                    ),
                    const SizedBox(width: 16),
                    const ScheduleSectionItem(
                      title: 'Jadwal Setoran Sampah',
                      subtitle: 'Setiap Bulan',
                      time: '10:00',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlobalButton(
            text: 'Tambahkan Jadwal Setoran ke Kalender',
            variant: ButtonVariant.medium,
            onPressed: () {},
          ),
          const SizedBox(height: 32),
          const GlobalText(
            text: 'Lokasi Bank Sampah',
            variant: TextVariant.largeBold,
            color: Colors.black,
          ),
          const SizedBox(height: 12),
          const WasteBankMap(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
