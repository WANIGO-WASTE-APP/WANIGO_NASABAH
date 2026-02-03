import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:wanigo_nasabah/routes/app_routes.dart';
import 'package:wanigo_ui/wanigo_ui.dart';
import 'package:wanigo_nasabah/data/models/tabungan_model.dart';

class TabunganCard extends StatelessWidget {
  final TabunganModel tabungan;

  const TabunganCard({super.key, required this.tabungan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFF003CFF),
            Color(0xFF0097FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: GlobalShadow.getShadow(ShadowVariant.medium),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            15.r), // Match container radius minus border width
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset(
                'assets/icons/waves_top_icon.svg',
              ),
            ),
            Positioned(
              bottom: -10,
              right: 0,
              child: SvgPicture.asset(
                'assets/icons/waves_bottom_icon.svg',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 16.r, bottom: 8.r, left: 16.r, right: 16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: 8.h),
                        GlobalText(
                          text: tabungan.formattedSaldo,
                          variant: TextVariant.h4,
                          color: Colors.white,
                        ),
                        SizedBox(height: 26.h),
                        GlobalText(
                          text: 'Total Sampah Terpilahkan',
                          variant: TextVariant.smallSemiBold,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        GlobalText(
                          text: tabungan.formattedBerat,
                          variant: TextVariant.h4,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menggunakan ElevatedButton dengan padding yang lebih kecil dan radius yang sangat melengkung
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.withdrawBalance);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.blue600,
                            elevation: 0,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h), // Padding disesuaikan
                          ),
                          child: GlobalText(
                            text: 'Cek Tabungan',
                            variant: TextVariant.xSmallBold,
                            color: AppColors.blue700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Tampilkan image langsung, tanpa background putih di belakangnya
                        Image.asset(
                          'assets/icons/trash_recycle.png',
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit
                              .contain, // Pastikan gambar terlihat seluruhnya
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint(
                                'Error loading trash_recycle.png: $error');
                            return Icon(
                              Icons.recycling,
                              size: 80.r, // Ukuran icon juga disesuaikan
                              color: AppColors
                                  .blue600, // Warna icon diubah agar kontras
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
