import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/song.dart';

// Web-only import. This service will compile for web because this file is
// still included; the import is safe as long as dart:html is available
// in the web build.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

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
    if (kIsWeb) {
      notifyListeners();
      return;
    }

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
    if (kIsWeb) {
      throw PlatformException(
        code: 'UNSUPPORTED',
        message: 'File system access not supported on web',
      );
    }

    final appDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${appDir.path}/music_downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  Future<bool> _downloadOnWeb({required String url, required String fileName}) async {
    try {
      // Browsers handle saving to the user's Downloads folder.
      final anchor = html.AnchorElement(href: url);
      anchor.download = fileName;
      anchor.target = '_blank';
      anchor.rel = 'noopener';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> downloadSong(Song song) async {
    if (_downloading[song.id] == true || _localPaths[song.id] != null) return;

    // Web: anchor download.
    if (kIsWeb) {
      try {
        if (!song.audioUrl.startsWith('http')) return;

        _downloading[song.id] = true;
        _progress[song.id] = 0.0;
        notifyListeners();

        final ok = await _downloadOnWeb(url: song.audioUrl, fileName: '${song.id}.mp3');

        // Anchor downloads don't provide progress.
        _progress[song.id] = ok ? 1.0 : 0.0;
      } catch (_) {
        _progress[song.id] = 0.0;
      } finally {
        _downloading[song.id] = false;
        notifyListeners();
      }

      return;
    }

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
    } catch (_) {
      _progress[song.id] = 0.0;
    } finally {
      _downloading[song.id] = false;
      notifyListeners();
    }
  }

  Future<void> deleteDownload(String songId) async {
    if (kIsWeb) return;

    final path = _localPaths[songId];
    if (path == null) return;

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    _localPaths.remove(songId);
    _progress.remove(songId);
    notifyListeners();
  }

  String getAudioUrl(Song song) {
    final local = _localPaths[song.id];
    if (local != null && File(local).existsSync()) {
      return local;
    }
    return song.audioUrl;
  }
}
