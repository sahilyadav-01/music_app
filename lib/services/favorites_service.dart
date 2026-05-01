import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';

class FavoritesService extends ChangeNotifier {
  static const String _boxName = 'favorites';
  late Box _box;
  List<String> _favoriteIds = [];

  List<String> get favoriteIds => _favoriteIds;

  FavoritesService() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_boxName);
    _favoriteIds = List<String>.from(_box.get('ids', defaultValue: <String>[]));
    notifyListeners();
  }

  bool isFavorite(String songId) => _favoriteIds.contains(songId);

  Future<void> toggleFavorite(Song song) async {
    if (_favoriteIds.contains(song.id)) {
      _favoriteIds.remove(song.id);
    } else {
      _favoriteIds.add(song.id);
    }
    await _box.put('ids', _favoriteIds);
    notifyListeners();
  }

  Future<void> removeFavorite(String songId) async {
    _favoriteIds.remove(songId);
    await _box.put('ids', _favoriteIds);
    notifyListeners();
  }

  List<Song> getFavoriteSongs(List<Song> allSongs) {
    return allSongs.where((song) => _favoriteIds.contains(song.id)).toList();
  }
}
