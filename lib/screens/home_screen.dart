import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_api_service.dart';
import '../services/audio_player_service.dart';
import '../widgets/song_tile.dart';
import '../widgets/song_image.dart';
import 'now_playing_screen.dart';
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
          _buildSectionHeader(
            'Recent',
            onSeeAll: () => _showFullList(context, 'Recent', recentSongs),
          ),
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
          _buildSectionHeader('Live Now', onSeeAll: () => _navigateToLive(context)),
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
          _buildSectionHeader(
            'For You',
            onSeeAll: () => _showFullList(context, 'For You', forYouSongs),
          ),
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

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
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
              onPressed: onSeeAll,
              child: const Text('See all', style: TextStyle(color: Color(0xFF673AB7))),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullList(BuildContext context, String title, List<Song> songs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) =>
                    SongTile(song: songs[index], playlist: songs, index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLive(BuildContext context) {
    // Switch to Live tab (index 1)
    final mainState = context.findAncestorStateOfType<State>();
    if (mainState != null && mainState.mounted) {
      // We need to find the MainTabScreen and switch to Live tab
      // For now, just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Switching to Live tab...'),
          backgroundColor: Color(0xFF673AB7),
        ),
      );
    }
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NowPlayingScreen()));
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
