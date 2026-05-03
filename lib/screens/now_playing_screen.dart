import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:share_plus/share_plus.dart';

import '../services/audio_player_service.dart';
import '../services/favorites_service.dart';
import '../widgets/song_image.dart';
import '../widgets/music_visualizer.dart';
import '../widgets/queue_sheet.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _pulseController;
  Color? dominantColor;
  PaletteGenerator? paletteGenerator;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _generatePalette());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _generatePalette() async {
    final player = context.read<AudioPlayerService>();
    final song = player.currentSong;
    if (song == null) return;

    paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(song.imageUrl),
      size: const Size(200, 200),
    );
    if (mounted) {
      setState(() {
        dominantColor = paletteGenerator?.dominantColor?.color ?? const Color(0xFF673AB7);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final player = context.watch<AudioPlayerService>();
    final favorites = context.watch<FavoritesService>();
    final song = player.currentSong;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (song == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isFavorite = favorites.isFavorite(song.id);
    final albumSize = (screenWidth * 0.75).clamp(220.0, screenHeight * 0.4);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              dominantColor?.withValues(alpha: 0.3) ?? const Color(0xFF1A0A2E),
              const Color(0xFF0A0A0A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        favorites.toggleFavorite(song);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () =>
                          Share.share('Listening to ${song.title} by ${song.artist}! 🎵'),
                    ),
                  ],
                ),
              ),

              // Album art & song info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visualizer
                        const SizedBox(height: 8),
                        SizedBox(width: 120, height: 6, child: MusicVisualizer()),
                        const SizedBox(height: 24),

                        // Album art
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        dominantColor?.withValues(alpha: 0.4) ??
                                        Colors.purple.withValues(alpha: 0.4),
                                    blurRadius: 30 + (20 * _pulseController.value),
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SongImage(song: song, width: albumSize, height: albumSize),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Song title
                        Text(
                          song.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Artist
                        Text(
                          song.artist,
                          style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),

                        // Album
                        Text(
                          song.album ?? 'Single',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Controls
              Padding(
                padding: EdgeInsets.fromLTRB(32, 0, 32, MediaQuery.of(context).padding.bottom + 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress slider
                    StreamBuilder<Duration>(
                      stream: player.audioPlayer.positionStream,
                      builder: (context, posSnapshot) {
                        final position = posSnapshot.data ?? Duration.zero;
                        final duration = player.duration;
                        return Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: duration.inMilliseconds > 0
                                    ? (position.inMilliseconds / duration.inMilliseconds).clamp(
                                        0.0,
                                        1.0,
                                      )
                                    : 0,
                                onChanged: (v) => player.audioPlayer.seek(
                                  Duration(milliseconds: (v * duration.inMilliseconds).round()),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Play controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: player.isShuffled ? dominantColor : Colors.white70,
                          ),
                          onPressed: player.toggleShuffle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous_rounded, size: 36),
                          onPressed: player.hasPrevious ? player.skipToPrevious : null,
                        ),
                        Container(
                          decoration: BoxDecoration(color: dominantColor, shape: BoxShape.circle),
                          child: IconButton(
                            icon: StreamBuilder<PlayerState>(
                              stream: player.audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data?.playing ?? false;
                                return Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 40,
                                  color: Colors.white,
                                );
                              },
                            ),
                            iconSize: 40,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              player.isPlaying ? player.pause() : player.play();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded, size: 36),
                          onPressed: player.hasNext ? player.skipToNext : null,
                        ),
                        IconButton(
                          icon: Icon(
                            player.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                            color: player.loopMode != LoopMode.off ? dominantColor : Colors.white70,
                          ),
                          onPressed: player.toggleLoopMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.lyrics, color: Colors.white70),
                          onPressed: () => _showLyrics(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.queue_music, color: Colors.white70),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const QueueSheet(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLyrics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Lyrics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    Text('Lyrics not available', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
