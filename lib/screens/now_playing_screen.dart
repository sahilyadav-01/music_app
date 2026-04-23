import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';
import '../models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NowPlayingScreen extends StatelessWidget {
  final Song song;

  const NowPlayingScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerService>(
      builder: (context, player, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.deepPurple.shade900],
              ),
            ),
            child: Column(
              children: [
                // Art
                Expanded(
                  child: Hero(
                    tag: song.id,
                    child: Container(
                      margin: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)],
                      ),
                      child: CircleAvatar(
                        backgroundImage: song.imageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(song.imageUrl)
                            : null,
                        backgroundColor: song.isLive ? Colors.red : Colors.purple,
                        radius: 100,
                        child: song.imageUrl.isEmpty
                            ? Icon(Icons.music_note, size: 80, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
                // Info & Controls
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Hero(
                          tag: '${song.id}_title',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              song.title,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(song.artist, style: TextStyle(fontSize: 18, color: Colors.grey)),
                        if (song.isLive)
                          Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(height: 40),
                        // Progress
                        StreamBuilder<Duration>(
                          stream: player.audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = player.duration;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDuration(position)),
                                    Text(_formatDuration(duration)),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderThemeData(
                                    thumbColor: Colors.white,
                                    activeTrackColor: Colors.purple,
                                  ),
                                  child: Slider(
                                    value: position.inSeconds.toDouble().clamp(
                                      0,
                                      duration.inSeconds.toDouble(),
                                    ),
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    onChanged: (value) =>
                                        player.seek(Duration(seconds: value.toInt())),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 32),
                        // Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous, size: 40, color: Colors.white),
                              onPressed: () {},
                            ),
                            GestureDetector(
                              onTap: player.isPlaying ? player.pause : player.play,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Icon(
                                  player.isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next, size: 40, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildIconButton(Icons.favorite_border, Colors.white, () {}),
                            _buildIconButton(Icons.shuffle, Colors.grey, () {}),
                            _buildIconButton(Icons.repeat, Colors.grey, () {}),
                            _buildIconButton(Icons.share, Colors.grey, () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: onTap,
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
