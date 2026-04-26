import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_player_service.dart';
import '../models/song.dart';
import '../widgets/song_image.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;

  const NowPlayingScreen({super.key, required this.song});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isFavorite = false;

  IconData _loopIcon(LoopMode mode) {
    return switch (mode) {
      LoopMode.off => Icons.repeat,
      LoopMode.all => Icons.repeat_on,
      LoopMode.one => Icons.repeat_one_on,
    };
  }

  Color? _loopColor(LoopMode mode) {
    return mode == LoopMode.off ? Colors.grey : const Color(0xFF673AB7);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, player, child) {
        final song = player.currentSong ?? widget.song;
        final effectiveIndex = player.currentSong != null ? player.currentIndex : -1;
        final hasPrev = effectiveIndex > 0;
        final hasNext = effectiveIndex >= 0 && effectiveIndex < player.songs.length - 1;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => setState(() => _isFavorite = !_isFavorite),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0A2E), Color(0xFF0A0A0A)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Album Art
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Hero(
                        tag: song.id,
                        child: Material(
                          type: MaterialType.transparency,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(aspectRatio: 1, child: SongImage(song: song)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Info & Controls
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        song.artist,
                                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (song.isLive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Progress
                            StreamBuilder<Duration>(
                              stream: player.audioPlayer.positionStream,
                              builder: (context, snapshot) {
                                final position = snapshot.data ?? Duration.zero;
                                final duration = player.duration;
                                final max = duration.inSeconds > 0
                                    ? duration.inSeconds.toDouble()
                                    : 1.0;
                                final value = position.inSeconds.toDouble().clamp(0.0, max);
                                return Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 6,
                                        ),
                                        trackHeight: 4,
                                        thumbColor: Colors.white,
                                        activeTrackColor: const Color(0xFF673AB7),
                                        inactiveTrackColor: Colors.grey[800],
                                        overlayShape: SliderComponentShape.noOverlay,
                                      ),
                                      child: Slider(
                                        value: value,
                                        min: 0,
                                        max: max,
                                        onChanged: (val) =>
                                            player.seek(Duration(seconds: val.toInt())),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatDuration(position),
                                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                          ),
                                          Text(
                                            _formatDuration(duration),
                                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _loopIcon(player.loopMode),
                                    color: _loopColor(player.loopMode),
                                  ),
                                  iconSize: 24,
                                  onPressed: player.toggleLoopMode,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: hasPrev ? Colors.white : Colors.grey[600],
                                  ),
                                  iconSize: 36,
                                  onPressed: hasPrev ? player.skipToPrevious : null,
                                ),
                                GestureDetector(
                                  onTap: player.isPlaying ? player.pause : player.play,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF673AB7),
                                    ),
                                    child: Icon(
                                      player.isPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: hasNext ? Colors.white : Colors.grey[600],
                                  ),
                                  iconSize: 36,
                                  onPressed: hasNext ? player.skipToNext : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.shuffle, color: Colors.grey),
                                  iconSize: 24,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.devices, color: Colors.grey),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share, color: Colors.grey),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.queue_music, color: Colors.grey),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
