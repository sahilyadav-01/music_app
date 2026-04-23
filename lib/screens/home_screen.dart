import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../widgets/song_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Home'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.amber.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Good morning!', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle('Recent'),
              ...MockApiService.getMockSongs().map((song) => SongTile(song: song)),
              SizedBox(height: 16),
              _buildSectionTitle('Live Now'),
              ...MockApiService.getLiveSongs().take(3).map((song) => SongTile(song: song)),
              SizedBox(height: 16),
              _buildSectionTitle('For You'),
              ...MockApiService.getMockSongs().map((song) => SongTile(song: song)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
