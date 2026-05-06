import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanigo_nasabah/widgets/global_app_bar.dart';
import 'package:wanigo_ui/wanigo_ui.dart' hide GlobalAppBar;

class VideoPlayerScreen extends StatefulWidget {
  final String title;

  const VideoPlayerScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = true;
  double _currentPosition = 0.07;
  final String _currentTime = "0:07";
  final String _totalTime = "47:25";
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isFullScreen
          ? null
          : const GlobalAppBar(
              enableShadow: true,
              showBackButton: true,
            ),
      body: _isFullScreen
          ? _buildVideoPlayer()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video player
                _buildVideoPlayer(),

                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlobalText(
                    text: widget.title,
                    variant: TextVariant.h5,
                    color: const Color(0xFF263238),
                  ),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlobalText(
                        text: 'Deskripsi Video',
                        variant: TextVariant.mediumBold,
                        color: const Color(0xFF263238),
                      ),
                      const SizedBox(height: 8),
                      GlobalText(
                        text:
                            'Video ini menjelaskan langkah-langkah praktis dalam mengelola sampah organik dan anorganik dari rumah tangga. '
                            'Pelajari cara memilah sampah yang benar untuk didaur ulang.',
                        variant: TextVariant.smallRegular,
                        color: Colors.grey[700]!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Related List Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: GlobalText(
                    text: 'Daftar Konten Modul Lainnya',
                    variant: TextVariant.mediumBold,
                    color: const Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 8),

                // Related List
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey[200]),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.blue[700],
                            size: 24,
                          ),
                        ),
                        title: GlobalText(
                          text: 'Bagian ${index + 2}: Lanjutan Materi Edukasi',
                          variant: TextVariant.smallSemiBold,
                        ),
                        subtitle: GlobalText(
                          text: '10 menit  •  20 poin',
                          variant: TextVariant.xSmallRegular,
                        ),
                        trailing:
                            const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                title:
                                    'Bagian ${index + 2}: Lanjutan Materi Edukasi',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: _isFullScreen ? MediaQuery.of(context).size.height : 230,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Placeholder video icon
          Icon(
            Icons.video_camera_back_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),

          // Main controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.replay_10, color: Colors.white, size: 36),
                onPressed: () {},
              ),
              const SizedBox(width: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 48,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                icon:
                    const Icon(Icons.forward_10, color: Colors.white, size: 36),
                onPressed: () {},
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GlobalText(
                        text: _currentTime,
                        variant: TextVariant.xSmallRegular,
                        color: Colors.white,
                      ),
                      GlobalText(
                        text: ' / ',
                        variant: TextVariant.xSmallRegular,
                        color: Colors.white70,
                      ),
                      GlobalText(
                        text: _totalTime,
                        variant: TextVariant.xSmallRegular,
                        color: Colors.white70,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          _isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _toggleFullScreen,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 20,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: Colors.red,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: Colors.red,
                        overlayColor: Colors.red.withOpacity(0.3),
                      ),
                      child: Slider(
                        value: _currentPosition,
                        onChanged: (value) {
                          setState(() {
                            _currentPosition = value;
                          });
                        },
                      ),
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
}
