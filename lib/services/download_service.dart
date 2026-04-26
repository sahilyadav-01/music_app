import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/song.dart';

class DownloadService extends ChangeNotifier {
  final Dio _dio = Dio();
  final Map<String, double> _progress = {};
  final Map<String, bool> _downloading = {};
  final Map<String, String?> _localPaths = {};

  double? getProgress(String songId) => _progress[songId];
  bool isDownloading(String songId) => _downloading[songId] ?? false;
  bool isDownloaded(String songId) => _localPaths[songId] != null;
  String? getLocalPath(String songId) => _localPaths[songId];

  DownloadService() {
    _loadDownloadedSongs();
  }

  Future<void> _loadDownloadedSongs() async {
    final dir = await _getDownloadDir();
    if (!await dir.exists()) return;

    final files = await dir.list().toList();
    for (final file in files) {
      if (file is File && file.path.endsWith('.mp3')) {
        final id = file.uri.pathSegments.last.replaceAll('.mp3', '');
        _localPaths[id] = file.path;
      }
    }
    notifyListeners();
  }

  Future<Directory> _getDownloadDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/music_downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  Future<void> downloadSong(Song song) async {
    if (_downloading[song.id] == true || _localPaths[song.id] != null) return;
    if (!song.audioUrl.startsWith('http')) return;

    _downloading[song.id] = true;
    _progress[song.id] = 0.0;
    notifyListeners();

    try {
      final dir = await _getDownloadDir();
      final savePath = '${dir.path}/${song.id}.mp3';

      await _dio.download(
        song.audioUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _progress[song.id] = received / total;
            notifyListeners();
          }
        },
      );

      _localPaths[song.id] = savePath;
      _progress[song.id] = 1.0;
    } catch (e) {
      _progress[song.id] = 0.0;
    } finally {
      _downloading[song.id] = false;
      notifyListeners();
    }
  }

  Future<void> deleteDownload(String songId) async {
    final path = _localPaths[songId];
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      _localPaths.remove(songId);
      _progress.remove(songId);
      notifyListeners();
    }
  }

  String getAudioUrl(Song song) {
    final local = _localPaths[song.id];
    if (local != null && File(local).existsSync()) {
      return local;
    }
    return song.audioUrl;
  }
}
