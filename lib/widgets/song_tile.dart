import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../services/audio_player_service.dart';
import '../services/download_service.dart';
import '../../screens/now_playing_screen.dart';
import 'song_image.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final List<Song>? playlist;
  final int index;

  const SongTile({super.key, required this.song, this.playlist, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<AudioPlayerService>();
    final isCurrent = player.currentSong?.id == song.id;
    final isPlaying = player.isPlaying && isCurrent;

    void play() {
      if (playlist != null && playlist!.isNotEmpty) {
        player.playPlaylist(playlist!, startIndex: index);
      } else {
        player.playSong(song);
      }
    }

    return InkWell(
      onTap: () {
        if (!isCurrent) play();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NowPlayingScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 56, height: 56, child: SongImage(song: song)),
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
            _DownloadButton(song: song),
            const SizedBox(width: 4),
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
                  play();
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

class _DownloadButton extends StatelessWidget {
  final Song song;

  const _DownloadButton({required this.song});

  @override
  Widget build(BuildContext context) {
    final downloadService = context.read<DownloadService?>();
    if (downloadService == null || !song.audioUrl.startsWith('http')) {
      return const SizedBox.shrink();
    }

    if (downloadService.isDownloaded(song.id)) {
      return InkWell(
        onTap: () => downloadService.deleteDownload(song.id),
        child: const Icon(Icons.offline_pin, color: Color(0xFF673AB7), size: 28),
      );
    }

    if (downloadService.isDownloading(song.id)) {
      final progress = downloadService.getProgress(song.id) ?? 0;
      return SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          value: progress > 0 ? progress : null,
          strokeWidth: 2.5,
          color: const Color(0xFF673AB7),
        ),
      );
    }

    return InkWell(
      onTap: () => downloadService.downloadSong(song),
      child: const Icon(Icons.download_for_offline_outlined, color: Colors.grey, size: 28),
    );
  }
}

class _EqualizerBars extends StatefulWidget {
  @override
  _EqualizerBarsState createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars> with TickerProviderStateMixin {
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
