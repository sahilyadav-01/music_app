import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import 'download_service.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  DownloadService? _downloadService;

  Song? _currentSong;
  List<Song> _songs = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  LoopMode _loopMode = LoopMode.off;
  double _playbackSpeed = 1.0;
  bool _isShuffled = false;
  List<int> _shuffleOrder = [];

  Song? get currentSong => _currentSong;
  List<Song> get songs => _songs;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  AudioPlayer get audioPlayer => _audioPlayer;
  LoopMode get loopMode => _loopMode;
  double get playbackSpeed => _playbackSpeed;
  bool get isShuffled => _isShuffled;

  bool get hasPrevious => _songs.isNotEmpty && _currentIndex > 0;
  bool get hasNext => _songs.isNotEmpty && _currentIndex < _songs.length - 1;

  void setDownloadService(DownloadService service) {
    _downloadService = service;
  }

  AudioPlayerService() {
    _init();
  }

  Future<void> _init() async {
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < _songs.length) {
        _currentIndex = index;
        _currentSong = _songs[index];
        notifyListeners();
      }
    });
    _audioPlayer.loopModeStream.listen((mode) {
      _loopMode = mode;
      notifyListeners();
    });
    _audioPlayer.speedStream.listen((speed) {
      _playbackSpeed = speed;
      notifyListeners();
    });
  }

  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;
    _songs = List.from(songs);
    _currentIndex = startIndex.clamp(0, songs.length - 1);
    _currentSong = songs[_currentIndex];
    _generateShuffleOrder();

    final sources = _songs.map((song) {
      final url = _downloadService?.getAudioUrl(song) ?? song.audioUrl;
      if (url.startsWith('assets/')) {
        return AudioSource.asset(url);
      } else if (url.startsWith('file://') || url.startsWith('/')) {
        return AudioSource.uri(Uri.file(url));
      } else {
        return AudioSource.uri(Uri.parse(url));
      }
    }).toList();

    await _audioPlayer.setAudioSources(sources, initialIndex: _currentIndex);
    await _audioPlayer.setSpeed(_playbackSpeed);
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> playSong(Song song) async {
    await playPlaylist([song], startIndex: 0);
  }

  Future<void> play() async => await _audioPlayer.play();
  Future<void> pause() async => await _audioPlayer.pause();
  Future<void> seek(Duration position) async => await _audioPlayer.seek(position);
  Future<void> stop() async => await _audioPlayer.stop();

  Future<void> skipToNext() async {
    if (_songs.isEmpty) return;
    if (_currentIndex < _songs.length - 1) {
      await _audioPlayer.seekToNext();
    } else if (_loopMode == LoopMode.all) {
      await _audioPlayer.seek(Duration.zero, index: 0);
      await _audioPlayer.play();
    }
  }

  Future<void> skipToPrevious() async {
    if (_songs.isEmpty) return;
    if (_currentIndex > 0) {
      await _audioPlayer.seekToPrevious();
    } else if (_loopMode == LoopMode.all) {
      await _audioPlayer.seek(Duration.zero, index: _songs.length - 1);
      await _audioPlayer.play();
    }
  }

  Future<void> toggleLoopMode() async {
    final nextMode = switch (_loopMode) {
      LoopMode.off => LoopMode.all,
      LoopMode.all => LoopMode.one,
      LoopMode.one => LoopMode.off,
    };
    await _audioPlayer.setLoopMode(nextMode);
  }

  Future<void> toggleShuffle() async {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _generateShuffleOrder();
    } else {
      _shuffleOrder.clear();
    }
    notifyListeners();
  }

  void _generateShuffleOrder() {
    _shuffleOrder = List.generate(_songs.length, (i) => i)..shuffle();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.5, 2.0);
    await _audioPlayer.setSpeed(_playbackSpeed);
    notifyListeners();
  }

  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
