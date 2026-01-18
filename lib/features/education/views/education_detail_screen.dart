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
  bool _bookmarked = false;
  double _readProgress = 0.0;
  bool _isLoading = true;
  bool _showGallery = false;
  ScrollController _scrollController = ScrollController();

  // Dummy data untuk contoh
  late Map<String, dynamic> _artikelData;
  late List<Map<String, dynamic>> _galleryImages;

  @override
  void initState() {
    super.initState();
    _loadArtikelData();

    // Mendeteksi scroll untuk memperbarui progress membaca
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        double progress = _scrollController.offset /
            (_scrollController.position.maxScrollExtent);
        setState(() {
          _readProgress = progress.clamp(0.0, 1.0);
        });

        // Update progress ke API jika sudah di posisi tertentu
        if (progress > 0.9 && _readProgress < 1.0) {
          _updateArtikelProgress(1.0, true);
        } else if (progress > 0.5 && _readProgress < 0.5) {
          _updateArtikelProgress(0.5, false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Simulasi loading data artikel dari API
  Future<void> _loadArtikelData() async {
    // Simulasi network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _artikelData = {
        "id": widget.artikelId,
        "judul_konten": widget.title,
        "deskripsi":
            "Artikel ini menjelaskan tentang jenis-jenis sampah dan bagaimana cara pengelolaannya yang benar untuk mendukung ekonomi sirkular.",
        "content": """<h2>Mengenal Jenis-jenis Sampah</h2>
<p>Sampah dapat dikategorikan menjadi beberapa jenis berdasarkan sumbernya, sifatnya, dan cara pengelolaannya.</p>
<h3>1. Sampah Organik</h3>
<p>Sampah organik adalah sampah yang berasal dari makhluk hidup dan dapat terurai secara alami. Contohnya: sisa makanan, daun, ranting, dll.</p>
<h3>2. Sampah Anorganik</h3>
<p>Sampah anorganik adalah sampah yang sulit terurai secara alami dan membutuhkan waktu lama untuk hancur. Contohnya: plastik, kaca, logam, dll.</p>
<h3>3. Sampah B3 (Bahan Berbahaya dan Beracun)</h3>
<p>Sampah B3 adalah sampah yang mengandung zat berbahaya dan beracun. Contohnya: baterai, lampu neon, kemasan pestisida, dll.</p>""",
        "thumbnail_url": widget.thumbnail,
        "durasi": 480,
        "poin": 15,
        "modul_id": 1,
        "judul_modul": "Pengenalan Pengelolaan Sampah",
        "progress": 0.0,
        "is_completed": false,
      };

      _galleryImages = [
        {
          "id": 1,
          "image_url": "https://example.com/images/gallery/sampah-organik.jpg",
          "caption": "Contoh sampah organik yang bisa dikompos",
          "urutan": 1
        },
        {
          "id": 2,
          "image_url":
              "https://example.com/images/gallery/sampah-anorganik.jpg",
          "caption": "Berbagai jenis sampah anorganik yang bisa didaur ulang",
          "urutan": 2
        },
      ];

      _isLoading = false;
    });
  }

  // Simulasi update progress membaca artikel ke API
  Future<void> _updateArtikelProgress(double progress, bool completed) async {
    // Simulasi request API update progress
    print('Updating artikel progress: $progress, completed: $completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        enableShadow: true,
        showBackButton: true,
        title: const Text(
          "Detail Edukasi", // Adding title back because typically Detail screens have titles, unlike Home screens.
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading ? _buildLoadingScreen() : _buildArtikelScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
          ),
          SizedBox(height: 16),
          Text(
            "Memuat artikel...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtikelScreen() {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar dengan gambar thumbnail
            // Thumbnail image section (moved from SliverAppBar)
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      _artikelData['thumbnail_url'] ??
                          'https://via.placeholder.com/400',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.blue[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                  // Title overlay on image if needed, or remove if title is in AppBar
                  // Keeping it clean as title is in AppBar now
                ],
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modul Info
                    Row(
                      children: [
                        const Icon(Icons.menu_book,
                            size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          "Modul: ${_artikelData['judul_modul']}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Time and Points
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${(_artikelData['durasi'] / 60).floor()} menit baca",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.stars, size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          "${_artikelData['poin']} poin",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Deskripsi
                    Text(
                      _artikelData['deskripsi'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Content HTML
                    _buildHtmlContent(_artikelData['content']),

                    // Related Content Section
                    const SizedBox(height: 32),
                    const Text(
                      "Konten Terkait",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Related content cards
                    _buildRelatedContentList(),

                    // Bottom space
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Progress indicator at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Progress Membaca",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${(_readProgress * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _readProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Gallery overlay
        if (_showGallery) _buildGalleryOverlay(),
      ],
    );
  }

  Widget _buildHtmlContent(String htmlContent) {
    // Simplified HTML parser for demo
    // In real app, use flutter_html or any HTML rendering package

    List<Widget> contentWidgets = [];

    // Parse H2 tags
    final h2Regex = RegExp(r'<h2>(.*?)<\/h2>');
    final h2Matches = h2Regex.allMatches(htmlContent);

    for (var match in h2Matches) {
      String h2Text = match.group(1) ?? '';
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 16),
          child: Text(
            h2Text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    // Parse H3 tags
    final h3Regex = RegExp(r'<h3>(.*?)<\/h3>');
    final h3Matches = h3Regex.allMatches(htmlContent);

    for (var match in h3Matches) {
      String h3Text = match.group(1) ?? '';
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            h3Text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    // Parse paragraphs
    final pRegex = RegExp(r'<p>(.*?)<\/p>');
    final pMatches = pRegex.allMatches(htmlContent);

    for (var match in pMatches) {
      String pText = match.group(1) ?? '';
      contentWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            pText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  Widget _buildRelatedContentList() {
    List<Map<String, dynamic>> relatedContent = [
      {
        "id": 2,
        "judul_konten": "Cara Pemilahan Sampah yang Efektif",
        "tipe_konten": "video",
        "durasi": 360,
        "thumbnail": "https://example.com/thumbnail-pemilahan-sampah.jpg",
        "poin": 20
      },
      {
        "id": 3,
        "judul_konten": "Manfaat Ekonomi dari Pengelolaan Sampah",
        "tipe_konten": "artikel",
        "durasi": 420,
        "thumbnail": "https://example.com/thumbnail-ekonomi-sampah.jpg",
        "poin": 15
      },
    ];

    return Column(
      children: relatedContent.map((content) {
        bool isVideo = content["tipe_konten"] == "video";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).pop();
                // Navigate based on content type
                if (isVideo) {
                  // Navigate to video screen
                } else {
                  // Navigate to artikel screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationDetailScreen(
                        artikelId: content["id"],
                        title: content["judul_konten"],
                        thumbnail: content["thumbnail"],
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              content["thumbnail"],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (isVideo)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Content info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content["judul_konten"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                isVideo ? Icons.videocam : Icons.article,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isVideo ? "Video" : "Artikel",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${(content["durasi"] / 60).floor()} menit",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.stars,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${content["poin"]} poin",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGalleryOverlay() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showGallery = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Galeri Gambar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showGallery = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _galleryImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _galleryImages[index]["image_url"],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[700],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _galleryImages[index]["caption"],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
