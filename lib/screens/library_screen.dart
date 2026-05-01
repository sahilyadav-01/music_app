import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../services/mock_api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Song> _allSongs = MockApiService.getMockSongs();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: const Text('Your Library'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFF673AB7),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF673AB7),
              tabs: const [
                Tab(text: 'Playlists'),
                Tab(text: 'Artists'),
                Tab(text: 'Albums'),
                Tab(text: 'Liked Songs'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPlaylistsTab(),
            _buildArtistsTab(),
            _buildAlbumsTab(),
            _buildLikedSongsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    final playlists = [
      _Playlist(name: 'Favorites', icon: Icons.favorite, songCount: 12),
      _Playlist(name: 'Recently Played', icon: Icons.history, songCount: 24),
      _Playlist(name: 'Top Hits', icon: Icons.trending_up, songCount: 50),
      _Playlist(name: 'Chill Vibes', icon: Icons.spa, songCount: 30),
      _Playlist(name: 'Workout Mix', icon: Icons.fitness_center, songCount: 25),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: playlists.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Your Playlists',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
          );
        }
        final playlist = playlists[index - 1];
        return _PlaylistTile(playlist: playlist);
      },
    );
  }

  Widget _buildArtistsTab() {
    final Map<String, List<Song>> artistGroups = <String, List<Song>>{};
    for (final song in _allSongs) {
      final artist = song.artist.split(',').first.trim();
      artistGroups.putIfAbsent(artist, () => []).add(song);
    }

    final artists = artistGroups.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Artists',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
          );
        }
        final entry = artists[index - 1];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF2A2A2A),
            child: Text(entry.key[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
          ),
          title: Text(entry.key, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${entry.value.length} songs', style: TextStyle(color: Colors.grey[500])),
          trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
          onTap: () {
            _showArtistSongs(context, entry.key, entry.value);
          },
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    final Map<String, List<Song>> albumGroups = <String, List<Song>>{};
    for (final song in _allSongs) {
      albumGroups.putIfAbsent(song.album, () => []).add(song);
    }

    final albums = albumGroups.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: albums.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Albums',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
          );
        }
        final entry = albums[index - 1];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              color: const Color(0xFF2A2A2A),
              child: const Icon(Icons.album, color: Colors.grey),
            ),
          ),
          title: Text(entry.key, style: const TextStyle(color: Colors.white)),
          subtitle: Text('${entry.value.length} songs', style: TextStyle(color: Colors.grey[500])),
          trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
          onTap: () {
            _showAlbumSongs(context, entry.key, entry.value);
          },
        );
      },
    );
  }

  Widget _buildLikedSongsTab() {
    return Consumer<FavoritesService>(
      builder: (context, favoritesService, child) {
        final likedSongs = favoritesService.getFavoriteSongs(_allSongs);

        if (likedSongs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[700]),
                const SizedBox(height: 16),
                Text(
                  'No liked songs yet',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart on any song to add it here',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: likedSongs.length,
          itemBuilder: (context, index) =>
              SongTile(song: likedSongs[index], playlist: likedSongs, index: index),
        );
      },
    );
  }

  void _showArtistSongs(BuildContext context, String artist, List<Song> songs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF673AB7),
                    child: Text(
                      artist[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artist,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text('${songs.length} songs', style: TextStyle(color: Colors.grey[400])),
                      ],
                    ),
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

  void _showAlbumSongs(BuildContext context, String album, List<Song> songs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFF673AB7),
                      child: const Icon(Icons.album, color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text('${songs.length} songs', style: TextStyle(color: Colors.grey[400])),
                      ],
                    ),
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
}

class _Playlist {
  final String name;
  final IconData icon;
  final int songCount;

  _Playlist({required this.name, required this.icon, required this.songCount});
}

class _PlaylistTile extends StatelessWidget {
  final _Playlist playlist;

  const _PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF673AB7).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(playlist.icon, color: const Color(0xFF673AB7)),
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${playlist.songCount} songs',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Playing ${playlist.name}'),
                backgroundColor: const Color(0xFF673AB7),
              ),
            );
          },
        ),
      ),
    );
  }
}
