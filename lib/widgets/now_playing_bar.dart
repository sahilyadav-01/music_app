import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';
import '../../screens/now_playing_screen.dart';
import 'song_image.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, player, child) {
        final song = player.currentSong;
        if (song == null) return const SizedBox.shrink();

        final hasPrev = player.currentIndex > 0;
        final hasNext = player.currentIndex < player.songs.length - 1;

        return Material(
          color: const Color(0xFF1A1A1A),
          elevation: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              StreamBuilder<Duration>(
                stream: Stream.periodic(const Duration(milliseconds: 500), (_) => player.position),
                builder: (context, snapshot) {
                  final position = player.position;
                  final duration = player.duration;
                  final max = duration.inMilliseconds > 0
                      ? duration.inMilliseconds.toDouble()
                      : 1.0;
                  final value = position.inMilliseconds.toDouble().clamp(0.0, max);
                  return LinearProgressIndicator(
                    value: value / max,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF673AB7)),
                    minHeight: 2,
                  );
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
                  );
                },
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Hero(
                        tag: song.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(width: 32, height: 32, child: SongImage(song: song)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: hasPrev ? Colors.white : Colors.grey[600],
                        ),
                        iconSize: 24,
                        onPressed: hasPrev ? player.skipToPrevious : null,
                      ),
                      IconButton(
                        icon: Icon(
                          player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        iconSize: 24,
                        onPressed: player.isPlaying ? player.pause : player.play,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: hasNext ? Colors.white : Colors.grey[600],
                        ),
                        iconSize: 24,
                        onPressed: hasNext ? player.skipToNext : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
