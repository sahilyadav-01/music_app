import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class ImageService {
  static final Map<String, String?> _cache = {};

  /// Fetches a real cover image URL from the iTunes Search API.
  /// Returns the song's existing imageUrl if it's already a local asset.
  /// Falls back to the original imageUrl (placeholder) if the API fails.
  static Future<String> getCoverUrl(Song song) async {
    // Use local assets directly
    if (song.imageUrl.startsWith('assets/')) {
      return song.imageUrl;
    }

    final cacheKey = '${song.title}|${song.artist}';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey] ?? song.imageUrl;
    }

    try {
      final query = Uri.encodeComponent('${song.artist} ${song.title}');
      final url = 'https://itunes.apple.com/search?term=$query&entity=song&limit=1';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && (data['results'] as List).isNotEmpty) {
          final result = data['results'][0];
          String? artwork = result['artworkUrl100'] as String?;
          if (artwork != null && artwork.isNotEmpty) {
            // Upgrade to higher resolution
            artwork = artwork.replaceFirst('100x100', '600x600');
            _cache[cacheKey] = artwork;
            return artwork;
          }
        }
      }
    } catch (_) {
      // Silently fall back to placeholder on any error
    }

    _cache[cacheKey] = null;
    return song.imageUrl;
  }
}
