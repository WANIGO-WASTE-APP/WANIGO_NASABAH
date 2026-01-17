import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/tabungan_model.dart';

class TabunganCard extends StatelessWidget {
  final TabunganModel tabungan;

  const TabunganCard({super.key, required this.tabungan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 159.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        // Gunakan HANYA image untuk background, tanpa gradient
        image: const DecorationImage(
          image: AssetImage('assets/images/tabungan_card.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    text: 'Total Saldo Tabungan',
                    variant: TextVariant.smallSemiBold,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText(
                    text: 'Rp${tabungan.saldo.toStringAsFixed(2)}',
                    variant: TextVariant.h4,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  GlobalText(
                    text: 'Total Sampah Terpilahkan',
                    variant: TextVariant.smallSemiBold,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4.h),
                  GlobalText(
                    text: '${tabungan.beratSampah} kilogram',
                    variant: TextVariant.h5,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menggunakan ElevatedButton dengan padding yang lebih kecil dan radius yang sangat melengkung
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.blue600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.r, vertical: 8.r), // Padding dikurangi
                  ),
                  child: Text(
                    'Cek Tabungan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                // Tampilkan image langsung, tanpa background putih di belakangnya
                Image.asset(
                  'assets/images/trash_recycle.png',
                  width: 80
                      .r, // Ukuran gambar disesuaikan dengan container sebelumnya
                  height: 80.r,
                  fit: BoxFit.contain, // Pastikan gambar terlihat seluruhnya
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading trash_recycle.png: $error');
                    return Icon(
                      Icons.recycling,
                      size: 80.r, // Ukuran icon juga disesuaikan
                      color: Colors
                          .white, // Warna icon diubah ke putih agar kontras dengan background card
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
