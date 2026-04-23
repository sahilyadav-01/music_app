import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, player, child) {
        final song = player.currentSong;
        if (song == null) return SizedBox.shrink();

        return Container(
          height: 72,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, -2))],
            color: Colors.grey[900],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: song.imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(song.imageUrl)
                      : null,
                  backgroundColor: song.isLive ? Colors.red : Colors.purple,
                  child: song.imageUrl.isEmpty ? Icon(Icons.music_note, color: Colors.white) : null,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(song.artist, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(player.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: player.isPlaying ? player.pause : player.play,
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {},
              ),
              SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }
}
