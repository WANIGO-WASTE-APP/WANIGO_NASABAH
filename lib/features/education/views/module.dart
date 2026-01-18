import 'package:flutter/material.dart';
import 'package:wanigo_nasabah/features/education/views/module_video.dart';
import 'package:wanigo_nasabah/features/education/views/education_detail_screen.dart';

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

  // Dummy data untuk modul
  late Map<String, dynamic> _moduleData;
  late List<Map<String, dynamic>> _moduleContents;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    _loadModuleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Simulasi loading data modul
  Future<void> _loadModuleData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _moduleData = {
        "id": 1,
        "judul_modul": widget.title,
        "deskripsi":
            "Modul ini memperkenalkan konsep dasar pengelolaan sampah untuk lingkungan yang berkelanjutan.",
        "objektif": "Memahami jenis-jenis sampah dan cara pengelolaannya.",
        "benefit":
            "Kemampuan untuk memilah sampah dengan benar dan berkontribusi pada lingkungan.",
        "durasi_total": 120, // dalam menit
        "konten_total": 5,
        "poin": 100,
        "progress": 20.0
      };

      _moduleContents = [
        {
          "id": 1,
          "judul": "Mengenal Jenis-jenis Sampah",
          "tipe": "artikel",
          "durasi": 8, // menit
          "poin": 15,
          "selesai": true
        },
        {
          "id": 2,
          "judul": "Cara Pemilahan Sampah yang Efektif",
          "tipe": "video",
          "durasi": 6, // menit
          "poin": 20,
          "selesai": false,
          "progress": 45.0
        },
        {
          "id": 3,
          "judul": "Manfaat Ekonomi dari Pengelolaan Sampah",
          "tipe": "artikel",
          "durasi": 7, // menit
          "poin": 15,
          "selesai": false
        },
        {
          "id": 4,
          "judul": "Teknologi Modern untuk Pengolahan Sampah",
          "tipe": "video",
          "durasi": 8, // menit
          "poin": 25,
          "selesai": false
        },
        {
          "id": 5,
          "judul": "Menjadi Agen Perubahan dalam Pengelolaan Sampah",
          "tipe": "artikel",
          "durasi": 6, // menit
          "poin": 25,
          "selesai": false
        }
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: null,
        centerTitle: true,
        flexibleSpace: SafeArea(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/WANIGO_logo.png',
                  width: 24,
                  height: 24,
                  color: const Color(0xFF1E88E5),
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.eco,
                      color: Color(0xFF1E88E5),
                      size: 24,
                    );
                  },
                ),
                const Text(
                  "WANIGO!",
                  style: TextStyle(
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and module info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _moduleData["judul_modul"],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.description,
                              size: 16, color: Colors.blue[600]),
                          const SizedBox(width: 4),
                          Text('${_moduleData["konten_total"]} konten',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time,
                              size: 16, color: Colors.blue[600]),
                          const SizedBox(width: 4),
                          Text('${_moduleData["durasi_total"]} menit',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      const Text(
                        "Progress Modul",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _moduleData["progress"] / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${_moduleData["progress"].toInt()}%",
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkerboard image (placeholder)
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: GridView.count(
                    crossAxisCount: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(64, (index) {
                      int row = index ~/ 8;
                      int col = index % 8;
                      return Container(
                        color: (row + col) % 2 == 0
                            ? Colors.white
                            : Colors.grey[200],
                      );
                    }),
                  ),
                ),

                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _tabController.animateTo(0);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _tabController.index == 0
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'Deskripsi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _tabController.index == 0
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _tabController.animateTo(1);
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _tabController.index == 1
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              'Konten',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _tabController.index == 1
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Description tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tentang Modul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _moduleData["deskripsi"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Objektif Modul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _moduleData["objektif"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Benefit Modul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _moduleData["benefit"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // List benefits with check marks
                            _buildBenefitItem(
                                "Pemahaman tentang jenis-jenis sampah"),
                            _buildBenefitItem(
                                "Kemampuan untuk memilah sampah dengan tepat"),
                            _buildBenefitItem("Pengetahuan tentang daur ulang"),
                            _buildBenefitItem(
                                "Kontribusi pada kelestarian lingkungan"),
                            _buildBenefitItem(
                                "Meningkatkan kesadaran komunitas"),
                          ],
                        ),
                      ),

                      // Content tab
                      ListView.builder(
                        itemCount: _moduleContents.length,
                        itemBuilder: (context, index) {
                          final content = _moduleContents[index];
                          final bool isVideo = content["tipe"] == "video";
                          final bool isCompleted = content["selesai"] == true;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.green[600]
                                    : Colors.blue[600],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCompleted
                                    ? Icons.check
                                    : (isVideo
                                        ? Icons.play_arrow
                                        : Icons.article),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              content["judul"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "${isVideo ? 'Video' : 'Artikel'}  •  ${content["durasi"]} menit  •  ${content["poin"]} poin",
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              if (isVideo) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                      title: content["judul"],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EducationDetailScreen(
                                      artikelId: content["id"],
                                      title: content["judul"],
                                      thumbnail:
                                          "https://example.com/thumbnail.jpg", // placeholder
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
