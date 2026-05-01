import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchHistoryService extends ChangeNotifier {
  static const String _boxName = 'search_history';
  static const int _maxHistory = 10;
  late Box _box;
  List<String> _history = [];

  List<String> get history => _history;

  SearchHistoryService() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_boxName);
    _history = List<String>.from(_box.get('queries', defaultValue: <String>[]));
    notifyListeners();
  }

  List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _history.where((h) => h.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<void> addToHistory(String query) async {
    if (query.isEmpty) return;
    query = query.trim();
    if (_history.contains(query)) {
      _history.remove(query);
    }
    _history.insert(0, query);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }
    await _box.put('queries', _history);
    notifyListeners();
  }

  Future<void> removeFromHistory(String query) async {
    _history.remove(query);
    await _box.put('queries', _history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _box.put('queries', _history);
    notifyListeners();
  }
}
