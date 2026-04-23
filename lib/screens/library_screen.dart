import 'package:flutter/material.dart';
import '../services/mock_api_service.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = MockApiService.getMockSongs();
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) => SongTile(song: songs[index]),
      ),
    );
  }
}
