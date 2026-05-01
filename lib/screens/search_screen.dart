import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_api_service.dart';
import '../services/search_history_service.dart';
import '../models/song.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Song> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search songs, artists...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _results = [];
                        _hasSearched = false;
                        _showSuggestions = false;
                      });
                    },
                  )
                : null,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onSubmitted: (query) => _search(query),
          onChanged: (value) {
            setState(() {
              _showSuggestions = value.isNotEmpty;
            });
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF673AB7)))
          : _results.isNotEmpty
          ? ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) =>
                  SongTile(song: _results[index], playlist: _results, index: index),
            )
          : _showSuggestions
          ? _buildSuggestions()
          : _buildEmptyState(),
    );
  }

  Widget _buildSuggestions() {
    return Consumer<SearchHistoryService>(
      builder: (context, historyService, child) {
        final suggestions = historyService.getSuggestions(_controller.text);

        if (suggestions.isEmpty && _controller.text.isEmpty) {
          // Show recent searches when input is empty
          final history = historyService.history;
          if (history.isEmpty) {
            return _buildDefaultSuggestions();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await historyService.clearHistory();
                      },
                      child: const Text('Clear all', style: TextStyle(color: Color(0xFF673AB7))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final query = history[index];
                    return ListTile(
                      leading: Icon(Icons.history, color: Colors.grey[600]),
                      title: Text(query, style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.north_west, color: Colors.grey[600], size: 20),
                        onPressed: () {
                          _controller.text = query;
                          _search(query);
                        },
                      ),
                      onTap: () => _search(query),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (suggestions.isEmpty) {
          return _buildDefaultSuggestions();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final query = suggestions[index];
                  return ListTile(
                    leading: Icon(Icons.search, color: Colors.grey[600]),
                    title: Text(query, style: const TextStyle(color: Colors.white)),
                    onTap: () => _search(query),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultSuggestions() {
    final suggestions = ['Arijit Singh', 'Jazz', 'Rock', 'Pop', 'Bollywood', 'Classical'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Popular Searches',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[400]),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final query = suggestions[index];
              return ListTile(
                leading: Icon(Icons.trending_up, color: Colors.grey[600]),
                title: Text(query, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  _controller.text = query;
                  _search(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    if (_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text('No results found', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 64, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            'Search for your favorite music',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _showSuggestions = false;
      });
      return;
    }

    // Add to search history
    final historyService = context.read<SearchHistoryService>();
    await historyService.addToHistory(query);

    setState(() => _isLoading = true);
    final results = await MockApiService.searchSongs(query);
    setState(() {
      _results = results;
      _isLoading = false;
      _hasSearched = true;
      _showSuggestions = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
