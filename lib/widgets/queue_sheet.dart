import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';
import 'song_image.dart';

class QueueSheet extends StatelessWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Up Next',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Clear All', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<AudioPlayerService>(
                  builder: (context, player, child) {
                    if (player.songs.isEmpty) {
                      return Center(
                        child: Text('Queue is empty', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: player.songs.length,
                      itemBuilder: (context, index) {
                        final song = player.songs[index];
                        final isCurrent = player.currentIndex == index;
                        return ListTile(
                          leading: SongImage(song: song, width: 48, height: 48),
                          title: Text(
                            song.title,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(song.artist, style: TextStyle(color: Colors.grey[400])),
                          trailing: isCurrent
                              ? Icon(Icons.play_arrow, color: Colors.green, size: 24)
                              : IconButton(
                                  icon: Icon(Icons.close, color: Colors.grey),
                                  onPressed: () {
                                    // Remove from queue logic
                                  },
                                ),
                          selected: isCurrent,
                          onTap: () {
                            player.audioPlayer.seek(Duration.zero, index: index);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
