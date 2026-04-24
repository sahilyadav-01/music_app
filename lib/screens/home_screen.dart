import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../widgets/song_tile.dart';
import '../screens/now_playing_screen.dart';
import '../models/song.dart';

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
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 60),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Good morning!',
                      style: TextStyle(
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
                itemBuilder: (context, index) => _HorizontalSongCard(song: recentSongs[index]),
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
                itemBuilder: (context, index) => _HorizontalSongCard(song: liveSongs[index]),
              ),
            ),
          ),
          _buildSectionHeader('For You'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SongTile(song: forYouSongs[index]),
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

  const _HorizontalSongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
      ),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: song.imageUrl.isNotEmpty
                    ? Image.network(
                        song.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: song.isLive ? Colors.red : Colors.deepPurple,
                          child: const Icon(Icons.music_note, color: Colors.white),
                        ),
                      )
                    : Container(
                        color: song.isLive ? Colors.red : Colors.deepPurple,
                        child: const Icon(Icons.music_note, color: Colors.white),
                      ),
              ),
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
