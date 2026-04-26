import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = MockApiService.getMockSongs();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            title: Text('Your Library'),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildChip('Playlists'),
                  _buildChip('Artists'),
                  _buildChip('Albums'),
                  _buildChip('Liked Songs'),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Recently Added',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SongTile(song: songs[index], playlist: songs, index: index),
              childCount: songs.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return ActionChip(
      label: Text(label),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      backgroundColor: const Color(0xFF2A2A2A),
      side: BorderSide.none,
      onPressed: () {},
    );
  }
}
