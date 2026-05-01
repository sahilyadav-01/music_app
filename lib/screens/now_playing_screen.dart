import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

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
  late AnimationController _controller;
  late AnimationController _pulseController;
  Color? dominantColor;
  PaletteGenerator? paletteGenerator;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 20))..repeat();
    _pulseController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _generatePalette());
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _generatePalette() async {
    final player = context.read<AudioPlayerService>();
    final song = player.currentSong;
    if (song == null) return;

    paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(song.imageUrl),
      size: Size(200, 200),
    );
    if (mounted) {
      setState(() {
        dominantColor = paletteGenerator?.dominantColor?.color ?? Color(0xFF673AB7);
      });
    }
  }

  Widget _neumorphicIconButton({
    required IconData icon,
    VoidCallback? onPressed,
    Color? color,
    double size = 28.0,
    bool haptic = true,
  }) {
    return GestureDetector(
      onTapDown: haptic ? (_) => HapticFeedback.lightImpact() : null,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(size * 0.25),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: Offset(0, 6)),
            BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 8, offset: Offset(0, -3)),
          ],
        ),
        child: Icon(icon, size: size, color: color ?? Colors.white),
      ),
    );
  }

  void _showLyrics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Lyrics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Every night in my dreams...',
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                    Text(
                      'I see you, I feel you...',
                      style: TextStyle(color: Colors.white70, height: 1.5),
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

    if (song == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isFavorite = favorites.isFavorite(song.id);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              dominantColor?.withOpacity(0.2) ?? Color(0xFF0A0A0A),
              HSVColor.fromColor(dominantColor ?? Color(0xFF673AB7)).withAlpha(0.1).toColor(),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Spacer(),
                    // Favorite button
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
                      icon: Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () => Share.share('Check out ${song.title} by ${song.artist}! 🎵'),
                    ),
                  ],
                ),
              ),
              // Album art with blur backdrop & visualizer - make scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        // Visualizer
                        SizedBox(width: 200, height: 8, child: MusicVisualizer()),
                        SizedBox(height: 16),
                        // Album art
                        AnimatedBuilder(
                          animation: Listenable.merge([_controller, _pulseController]),
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _controller.value * 2 * math.pi,
                              child: Hero(
                                tag: song.id,
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            dominantColor?.withOpacity(0.6) ??
                                            Colors.white.withOpacity(0.3),
                                        blurRadius: 40,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(36),
                                    child: Transform.scale(
                                      scale: 1.0 + 0.08 * _pulseController.value,
                                      child: SongImage(song: song, width: 260, height: 260),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        // Song info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                song.title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                song.artist,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                song.album ?? 'Single',
                                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              // Controls
              Padding(
                padding: EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Column(
                  children: [
                    // Progress with buffer
                    StreamBuilder<Duration>(
                      stream: player.audioPlayer.positionStream,
                      builder: (context, posSnapshot) {
                        final position = posSnapshot.data ?? Duration.zero;
                        final duration = player.duration;
                        return StreamBuilder<Duration?>(
                          stream: player.bufferedPositionStream,
                          builder: (context, bufSnapshot) {
                            final buffered = bufSnapshot.data ?? position;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _formatDuration(position),
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(
                                      _formatDuration(duration),
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Stack(
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        inactiveTrackColor: Colors.grey[800],
                                        trackHeight: 4,
                                      ),
                                      child: Slider(
                                        value: duration.inMilliseconds > 0
                                            ? position.inMilliseconds / duration.inMilliseconds
                                            : 0,
                                        onChanged: (v) => player.audioPlayer.seek(
                                          Duration(
                                            milliseconds: (v * duration.inMilliseconds).round(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.green.withOpacity(0.6),
                                          trackHeight: 4,
                                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                                        ),
                                        child: Slider(
                                          value: duration.inMilliseconds > 0
                                              ? buffered.inMilliseconds / duration.inMilliseconds
                                              : 0,
                                          onChanged: null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 40),
                    // Main play controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _neumorphicIconButton(
                          icon: Icons.skip_previous_rounded,
                          size: 36,
                          onPressed: player.hasPrevious ? player.skipToPrevious : null,
                        ),
                        SizedBox(width: 40),
                        GestureDetector(
                          onTapDown: (_) => _pulseController.forward(),
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            if (player.isPlaying) {
                              player.pause();
                            } else {
                              player.play();
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  dominantColor ?? Color(0xFF673AB7),
                                  (dominantColor ?? Color(0xFF673AB7)).withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      dominantColor?.withOpacity(0.5) ??
                                      Colors.purple.withOpacity(0.5),
                                  blurRadius: 50,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: StreamBuilder<PlayerState>(
                              stream: player.audioPlayer.playerStateStream,
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data?.playing ?? false;
                                return Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 60,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                        _neumorphicIconButton(
                          icon: Icons.skip_next_rounded,
                          size: 36,
                          onPressed: player.hasNext ? player.skipToNext : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    // Speed controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [0.5, 1.0, 1.5, 2.0]
                          .map(
                            (speed) => _neumorphicIconButton(
                              icon: Icons.speed,
                              color: player.playbackSpeed == speed ? dominantColor : Colors.white70,
                              size: 24,
                              onPressed: () => player.setPlaybackSpeed(speed),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 24),
                    // Bottom controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _neumorphicIconButton(
                          icon: player.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                          color: player.loopMode != LoopMode.off ? dominantColor : null,
                          onPressed: player.toggleLoopMode,
                        ),
                        _neumorphicIconButton(
                          icon: Icons.shuffle,
                          color: player.isShuffled ? dominantColor : null,
                          onPressed: player.toggleShuffle,
                        ),
                        _neumorphicIconButton(
                          icon: Icons.lyrics,
                          onPressed: () => _showLyrics(context),
                        ),
                        _neumorphicIconButton(
                          icon: Icons.queue_music,
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => QueueSheet(),
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
}
