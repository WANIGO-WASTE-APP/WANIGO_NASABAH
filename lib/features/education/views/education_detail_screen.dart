import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class EducationDetailScreen extends StatefulWidget {
  final int artikelId;
  final String title;
  final String thumbnail;

  const EducationDetailScreen({
    Key? key,
    required this.artikelId,
    required this.title,
    required this.thumbnail,
  }) : super(key: key);

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  bool _isLoading = true;
  double _readProgress = 0.0;
  final ScrollController _scrollController = ScrollController();

  late Map<String, dynamic> _artikelData;

  @override
  void initState() {
    super.initState();
    _loadArtikelData();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      final progress =
          _scrollController.offset / _scrollController.position.maxScrollExtent;
      setState(() {
        _readProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadArtikelData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _artikelData = {
        'id': widget.artikelId,
        'judul_konten': widget.title,
        'deskripsi':
            'Artikel ini menjelaskan tentang jenis-jenis sampah dan bagaimana cara pengelolaannya yang benar untuk mendukung ekonomi sirkular.',
        'judul_modul': 'Pengenalan Pengelolaan Sampah',
        'durasi': 480,
        'poin': 15,
        'is_completed': false,
        'paragraphs': [
          {
            'type': 'heading',
            'text': 'Mengenal Jenis-jenis Sampah',
          },
          {
            'type': 'paragraph',
            'text':
                'Sampah dapat dikategorikan menjadi beberapa jenis berdasarkan sumbernya, sifatnya, dan cara pengelolaannya.',
          },
          {
            'type': 'subheading',
            'text': '1. Sampah Organik',
          },
          {
            'type': 'paragraph',
            'text':
                'Sampah organik adalah sampah yang berasal dari makhluk hidup dan dapat terurai secara alami. Contohnya: sisa makanan, daun, ranting, dll.',
          },
          {
            'type': 'subheading',
            'text': '2. Sampah Anorganik',
          },
          {
            'type': 'paragraph',
            'text':
                'Sampah anorganik adalah sampah yang sulit terurai secara alami dan membutuhkan waktu lama untuk hancur. Contohnya: plastik, kaca, logam, dll.',
          },
          {
            'type': 'subheading',
            'text': '3. Sampah B3 (Bahan Berbahaya dan Beracun)',
          },
          {
            'type': 'paragraph',
            'text':
                'Sampah B3 adalah sampah yang mengandung zat berbahaya dan beracun. Contohnya: baterai, lampu neon, kemasan pestisida, dll.',
          },
        ],
      };
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
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  GlobalText(
                    text: 'Memuat artikel...',
                    variant: TextVariant.smallRegular,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Thumbnail
                    SliverToBoxAdapter(
                      child: widget.thumbnail.isNotEmpty
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                widget.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildThumbnailPlaceholder(),
                              ),
                            )
                          : _buildThumbnailPlaceholder(),
                    ),

                    // Article content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            GlobalText(
                              text: _artikelData['judul_konten'],
                              variant: TextVariant.h4,
                              color: const Color(0xFF263238),
                            ),
                            const SizedBox(height: 10),

                            // Module & meta info
                            Row(
                              children: [
                                Icon(Icons.menu_book,
                                    size: 15, color: Colors.blue[700]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: GlobalText(
                                    text:
                                        'Modul: ${_artikelData["judul_modul"]}',
                                    variant: TextVariant.smallMedium,
                                    color: Colors.blue[700]!,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 15, color: Colors.grey),
                                const SizedBox(width: 4),
                                GlobalText(
                                  text:
                                      '${(_artikelData["durasi"] / 60).floor()} menit baca',
                                  variant: TextVariant.smallRegular,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.stars,
                                    size: 15, color: Colors.orange),
                                const SizedBox(width: 4),
                                GlobalText(
                                  text: '${_artikelData["poin"]} poin',
                                  variant: TextVariant.smallRegular,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Description
                            GlobalText(
                              text: _artikelData['deskripsi'],
                              variant: TextVariant.smallRegular,
                              color: Colors.grey[700]!,
                            ),
                            const SizedBox(height: 24),

                            // Parsed content
                            ..._buildContent(
                              List<Map<String, dynamic>>.from(
                                  _artikelData['paragraphs']),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Read progress bar at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GlobalText(
                              text: 'Progress Membaca',
                              variant: TextVariant.smallMedium,
                            ),
                            GlobalText(
                              text: '${(_readProgress * 100).toInt()}%',
                              variant: TextVariant.smallBold,
                              color: Colors.blue[700]!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _readProgress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue[700]!),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.blue[50],
      child: Icon(Icons.article_outlined, size: 72, color: Colors.blue[200]),
    );
  }

  List<Widget> _buildContent(List<Map<String, dynamic>> paragraphs) {
    return paragraphs.map((item) {
      switch (item['type']) {
        case 'heading':
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: GlobalText(
              text: item['text'],
              variant: TextVariant.h5,
              color: const Color(0xFF1565C0),
            ),
          );
        case 'subheading':
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: GlobalText(
              text: item['text'],
              variant: TextVariant.mediumBold,
              color: const Color(0xFF1976D2),
            ),
          );
        case 'paragraph':
        default:
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlobalText(
              text: item['text'],
              variant: TextVariant.smallRegular,
              color: Colors.grey[800]!,
            ),
          );
      }
    }).toList();
  }
}
