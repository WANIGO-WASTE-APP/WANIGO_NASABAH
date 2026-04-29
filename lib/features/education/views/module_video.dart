import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _currentTime = "0:07";
  String _totalTime = "47:25";
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    // Lock to portrait orientation by default
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation when leaving the screen
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
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.black87),
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
                        color: Color(0xFF1E88E5),
                      ),
                      Text(
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
      body: _isFullScreen
          ? _buildVideoPlayer()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video player area
                _buildVideoPlayer(),

                // Video title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Video description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deskripsi Video',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem Ipsum Dulur Lorem Ipsum Dulur Lorem Ipsum Dulur '
                        'Lorem Ipsum Dulur Lorem Ipsum Dulur Lorem Ipsum Dulur '
                        'Lorem Ipsum Dulur Lorem Ipsum Dulur Lorem Ipsum Dulur '
                        'Lorem Ipsum Dulur Lorem Ipsum Dulur Lorem Ipsum Dulur',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // Related content list
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Daftar Konten Modul Lainnya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Judul Konten Modul Edukasi Sampah',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text('100 poin  50exp'),
                        trailing: const Text(
                          '10:00',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          // Navigate to the same screen but with different content
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                title:
                                    'Judul Konten Modul Edukasi Sampah ${index + 1}',
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
    return Stack(
      children: [
        // Video content
        Container(
          width: double.infinity,
          height: _isFullScreen ? MediaQuery.of(context).size.height : 220,
          color: const Color(0xFF5F7D89),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sample architecture image - skyscrapers
              Icon(
                Icons.domain,
                size: 120,
                color: Colors.white.withOpacity(0.5),
              ),

              // Playback controls overlay
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 36),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 36),
                    onPressed: () {},
                  ),
                ],
              ),

              // Settings and more buttons on top right
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Time and fullscreen controls at bottom
              if (!_isFullScreen)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Time indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              _currentTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              ' / $_totalTime',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                _isFullScreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _toggleFullScreen,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),

                      // Progress bar
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
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
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
