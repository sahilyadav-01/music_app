import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_api_service.dart';
import '../services/audio_player_service.dart';
import '../widgets/song_tile.dart';
import '../widgets/song_image.dart';
import 'package:music_app/screens/now_playing_screen.dart';
import '../models/song.dart';
import '../utils/greeting_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recentSongs = MockApiService.getMockSongs();
    final liveSongs = MockApiService.getLiveSongs().take(5).toList();
    final forYouSongs = MockApiService.getMockSongs();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Premium Music'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A0A2E), Color(0xFF673AB7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 60),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      getGreeting(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildSectionHeader('Recent'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentSongs.length,
                itemBuilder: (context, index) => _HorizontalSongCard(
                  song: recentSongs[index],
                  playlist: recentSongs,
                  index: index,
                ),
              ),
            ),
          ),
          _buildSectionHeader('Live Now'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: liveSongs.length,
                itemBuilder: (context, index) =>
                    _HorizontalSongCard(song: liveSongs[index], playlist: liveSongs, index: index),
              ),
            ),
          ),
          _buildSectionHeader('For You'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  SongTile(song: forYouSongs[index], playlist: forYouSongs, index: index),
              childCount: forYouSongs.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See all', style: TextStyle(color: Color(0xFF673AB7))),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalSongCard extends StatelessWidget {
  final Song song;
  final List<Song>? playlist;
  final int index;

  const _HorizontalSongCard({required this.song, this.playlist, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (playlist != null && playlist!.isNotEmpty) {
          context.read<AudioPlayerService>().playPlaylist(playlist!, startIndex: index);
        } else {
          context.read<AudioPlayerService>().playSong(song);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(aspectRatio: 1, child: SongImage(song: song)),
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              song.artist,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
