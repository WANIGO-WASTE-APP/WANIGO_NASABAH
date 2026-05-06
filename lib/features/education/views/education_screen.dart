import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/education/widgets/education_module_card.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _modules = [
    {
      'title': 'Mengenal Jenis dan Ciri Khas Sampah',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': true,
      'progress': 100,
      'iconData': Icons.delete_outline,
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Belajar Metode Pengolahan Sampah',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': false,
      'progress': 80,
      'iconData': Icons.recycling,
      'color': Color(0xFF1565C0),
    },
    {
      'title': 'Mengenal Bank Sampah',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': false,
      'progress': 80,
      'iconData': Icons.store_outlined,
      'color': Color(0xFFE65100),
    },
    {
      'title': 'Daur Ulang Sampah Plastik',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': false,
      'progress': 0,
      'iconData': Icons.water_drop_outlined,
      'color': Color(0xFF6A1B9A),
    },
    {
      'title': 'Kompos dari Sampah Organik',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': false,
      'progress': 0,
      'iconData': Icons.eco_outlined,
      'color': Color(0xFF558B2F),
    },
    {
      'title': 'Ekonomi Sirkular dan Sampah',
      'contentCount': 10,
      'duration': 100,
      'isCompleted': false,
      'progress': 0,
      'iconData': Icons.loop,
      'color': Color(0xFF37474F),
    },
  ];

  @override
  Widget build(BuildContext context) {
    print('DEBUG - EducationScreen build START');

    final completedCount =
        _modules.where((m) => m['isCompleted'] == true).length;

    print('DEBUG - EducationScreen completedCount: $completedCount');

    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: GlobalAppBar(
          enableShadow: true,
        ),
        body: Column(
          children: [
            // Header banner
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/education_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/edukasi_icon.svg',
                    width: 95.w,
                    height: 95.w,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        GlobalText(
                          text: 'Edukasi Sampah',
                          variant: TextVariant.h4,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4),
                        GlobalText(
                          text:
                              'Pelajari cara mengolah sampah dengan mudah, dapatkan manfaat ekonomis, sekaligus bantu jaga bumi kita',
                          variant: TextVariant.xSmallSemiBold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const GlobalText(
                    text: 'Daftar Modul Edukasi',
                    variant: TextVariant.mediumBold,
                    color: AppColors.gray600,
                  ),
                  Row(
                    children: [
                      GlobalText(
                        text: '$completedCount/${_modules.length}',
                        variant: TextVariant.smallBold,
                        color: AppColors.gray700,
                      ),
                      const SizedBox(width: 4),
                      const GlobalText(
                        text: 'terselesaikan',
                        variant: TextVariant.xSmallSemiBold,
                        color: AppColors.gray700,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Module cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _modules.length,
                itemBuilder: (context, index) {
                  final module = _modules[index];
                  return EducationModuleCard(
                    title: module['title'] as String,
                    contentCount: module['contentCount'] as int,
                    duration: module['duration'] as int,
                    isCompleted: module['isCompleted'] as bool,
                    progress: module['progress'] as int,
                    iconData: module['iconData'] as IconData,
                    placeholderColor: module['color'] as Color,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('DEBUG - EducationScreen build ERROR: $e');
      print('DEBUG - StackTrace: $stackTrace');
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: GlobalAppBar(enableShadow: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Terjadi kesalahan: $e', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
  }
}
