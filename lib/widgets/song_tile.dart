import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';
import '../services/audio_player_service.dart';
import '../screens/now_playing_screen.dart';

class SongTile extends StatelessWidget {
  final Song song;

  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<AudioPlayerService>();
    final isCurrent = player.currentSong?.id == song.id;
    final isPlaying = player.isPlaying && isCurrent;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: song.imageUrl.isNotEmpty
                    ? (song.imageUrl.startsWith('assets/')
                          ? Image.asset(song.imageUrl, fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: song.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: song.isLive ? Colors.red : Colors.deepPurple),
                              errorWidget: (context, url, error) => Container(
                                color: song.isLive ? Colors.red : Colors.deepPurple,
                                child: const Icon(Icons.music_note, color: Colors.white),
                              ),
                            ))
                    : Container(
                        color: song.isLive ? Colors.red : Colors.deepPurple,
                        child: const Icon(Icons.music_note, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? const Color(0xFF673AB7) : Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (song.isLive)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          song.artist,
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (isCurrent && isPlaying)
              _EqualizerBars()
            else
              Text(
                _formatDuration(song.duration),
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: isCurrent ? const Color(0xFF673AB7) : Colors.white,
                size: 32,
              ),
              onPressed: () {
                if (isCurrent) {
                  isPlaying ? player.pause() : player.play();
                } else {
                  player.playSong(song);
                }
              },
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

class _EqualizerBars extends StatefulWidget {
  @override
  __EqualizerBarsState createState() => __EqualizerBarsState();
}

class __EqualizerBarsState extends State<_EqualizerBars> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 100),
        lowerBound: 0.3,
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _controllers.map((ctrl) {
        return AnimatedBuilder(
          animation: ctrl,
          builder: (context, child) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            width: 3,
            height: 12 * ctrl.value,
            decoration: BoxDecoration(
              color: const Color(0xFF673AB7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
