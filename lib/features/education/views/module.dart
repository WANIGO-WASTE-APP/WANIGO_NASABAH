import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_nasabah/features/education/views/module_video.dart';
import 'package:wanigo_nasabah/features/education/views/education_detail_screen.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class ModuleDetailScreen extends StatefulWidget {
  final String title;

  const ModuleDetailScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  late Map<String, dynamic> _moduleData;
  late List<Map<String, dynamic>> _moduleContents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) setState(() {});
    });
    _loadModuleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadModuleData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _moduleData = {
        'id': 1,
        'judul_modul': widget.title,
        'deskripsi':
            'Modul ini memperkenalkan konsep dasar pengelolaan sampah untuk lingkungan yang berkelanjutan.',
        'objektif': 'Memahami jenis-jenis sampah dan cara pengelolaannya.',
        'benefit':
            'Kemampuan untuk memilah sampah dengan benar dan berkontribusi pada lingkungan.',
        'durasi_total': 120,
        'konten_total': 5,
        'poin': 100,
        'progress': 20.0,
      };

      _moduleContents = [
        {
          'id': 1,
          'judul': 'Mengenal Jenis-jenis Sampah',
          'tipe': 'artikel',
          'durasi': 8,
          'poin': 15,
          'selesai': true,
        },
        {
          'id': 2,
          'judul': 'Cara Pemilahan Sampah yang Efektif',
          'tipe': 'video',
          'durasi': 6,
          'poin': 20,
          'selesai': false,
          'progress': 45.0,
        },
        {
          'id': 3,
          'judul': 'Manfaat Ekonomi dari Pengelolaan Sampah',
          'tipe': 'artikel',
          'durasi': 7,
          'poin': 15,
          'selesai': false,
        },
        {
          'id': 4,
          'judul': 'Teknologi Modern untuk Pengolahan Sampah',
          'tipe': 'video',
          'durasi': 8,
          'poin': 25,
          'selesai': false,
        },
        {
          'id': 5,
          'judul': 'Menjadi Agen Perubahan dalam Pengelolaan Sampah',
          'tipe': 'artikel',
          'durasi': 6,
          'poin': 25,
          'selesai': false,
        },
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        enableShadow: true,
        showBackButton: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module header info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalText(
                        text: _moduleData['judul_modul'],
                        variant: TextVariant.h4,
                        color: const Color(0xFF263238),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/book_icon.svg',
                            width: 15.w,
                            height: 15.h,
                          ),
                          const SizedBox(width: 4),
                          GlobalText(
                            text: '${_moduleData["konten_total"]} konten',
                            variant: TextVariant.smallMedium,
                          ),
                          const SizedBox(width: 16),
                          SvgPicture.asset(
                            'assets/icons/clock_icon.svg',
                            width: 15.w,
                            height: 15.h,
                          ),
                          const SizedBox(width: 4),
                          GlobalText(
                            text: '${_moduleData["durasi_total"]} menit',
                            variant: TextVariant.smallMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GlobalText(
                            text: 'Progress Modul',
                            variant: TextVariant.smallMedium,
                          ),
                          GlobalText(
                            text:
                                '${(_moduleData["progress"] as double).toInt()}%',
                            variant: TextVariant.smallBold,
                            color: Colors.blue[700]!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (_moduleData['progress'] as double) / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Thumbnail placeholder
                Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.blue[50],
                  child:
                      Icon(Icons.recycling, size: 72, color: Colors.blue[200]),
                ),

                // Tabs
                GlobalTabMenu(
                  tabs: const ['Deskripsi', 'Konten'],
                  initialIndex: _tabController.index,
                  onTabSelected: (index) {
                    _tabController.animateTo(index);
                    setState(() {});
                  },
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDescriptionTab(),
                      _buildContentTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tentang Modul'),
          const SizedBox(height: 8),
          GlobalText(
            text: _moduleData['deskripsi'],
            variant: TextVariant.smallRegular,
            color: Colors.grey[800]!,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Objektif Modul'),
          const SizedBox(height: 8),
          GlobalText(
            text: _moduleData['objektif'],
            variant: TextVariant.smallRegular,
            color: Colors.grey[800]!,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Benefit Modul'),
          const SizedBox(height: 8),
          GlobalText(
            text: _moduleData['benefit'],
            variant: TextVariant.smallRegular,
            color: Colors.grey[800]!,
          ),
          const SizedBox(height: 16),
          _buildBenefitItem('Pemahaman tentang jenis-jenis sampah'),
          _buildBenefitItem('Kemampuan untuk memilah sampah dengan tepat'),
          _buildBenefitItem('Pengetahuan tentang daur ulang'),
          _buildBenefitItem('Kontribusi pada kelestarian lingkungan'),
          _buildBenefitItem('Meningkatkan kesadaran komunitas'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return GlobalText(
      text: text,
      variant: TextVariant.mediumBold,
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: GlobalText(
              text: text,
              variant: TextVariant.smallRegular,
              color: Colors.grey[800]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return ListView.separated(
      itemCount: _moduleContents.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final content = _moduleContents[index];
        final bool isVideo = content['tipe'] == 'video';
        final bool isCompleted = content['selesai'] == true;

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green[600] : Colors.blue[700],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : (isVideo ? Icons.play_arrow : Icons.article),
              color: Colors.white,
              size: 22,
            ),
          ),
          title: GlobalText(
            text: content['judul'],
            variant: TextVariant.smallSemiBold,
          ),
          subtitle: GlobalText(
            text:
                '${isVideo ? "Video" : "Artikel"}  •  ${content["durasi"]} menit  •  ${content["poin"]} poin',
            variant: TextVariant.xSmallRegular,
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            if (isVideo) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayerScreen(title: content['judul']),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationDetailScreen(
                    artikelId: content['id'],
                    title: content['judul'],
                    thumbnail: '',
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
