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

class _NowPlayingScreenState extends State<NowPlayingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Artwork
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + 0.1 * _controller.value,
                        child: Hero(
                          tag: widget.song.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: SongImage(song: widget.song),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.song.artist,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Controls
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Progress
                  StreamBuilder<Duration>(
                    stream: context.read<AudioPlayerService>().audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = context.read<AudioPlayerService>().duration ?? Duration.zero;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbColor: const Color(0xFF673AB7),
                                    activeTrackColor: const Color(0xFF673AB7),
                                    inactiveTrackColor: Colors.grey,
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: position.inMilliseconds.toDouble().clamp(
                                      0,
                                      duration.inMilliseconds.toDouble(),
                                    ),
                                    max: duration.inMilliseconds.toDouble(),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Play controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: context.read<AudioPlayerService>().hasPrevious
                                    ? context.read<AudioPlayerService>().skipToPrevious
                                    : null,
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  final player = context.read<AudioPlayerService>();
                                  if (player.isPlaying) {
                                    player.pause();
                                  } else {
                                    player.play();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF673AB7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: StreamBuilder<PlayerState>(
                                    stream: context
                                        .read<AudioPlayerService>()
                                        .audioPlayer
                                        .playerStateStream,
                                    builder: (context, snapshot) {
                                      final isPlaying = snapshot.data?.playing ?? false;
                                      return Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                        size: 48,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.skip_next, size: 40, color: Colors.white),
                                onPressed: context.read<AudioPlayerService>().hasNext
                                    ? context.read<AudioPlayerService>().skipToNext
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Repeat and shuffle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.repeat, color: Colors.grey),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.shuffle, color: Colors.grey),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
}
