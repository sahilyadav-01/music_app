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
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: song.imageUrl.isNotEmpty
            ? CachedNetworkImageProvider(song.imageUrl)
            : null,
        backgroundColor: song.isLive ? Colors.red : Colors.purple,
        child: song.imageUrl.isEmpty ? Icon(Icons.music_note, color: Colors.white) : null,
      ),
      title: Text(song.title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(song.artist),
          if (song.isLive) Text('LIVE', style: TextStyle(color: Colors.red, fontSize: 12)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(player.isPlaying && isCurrent ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (isCurrent) {
                if (player.isPlaying) {
                  player.pause();
                } else {
                  player.play();
                }
              } else {
                player.playSong(song);
              }
            },
          ),
          Text(_formatDuration(song.duration)),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
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
