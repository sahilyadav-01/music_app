import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import '../models/song.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  AudioPlayer get audioPlayer => _audioPlayer;

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
  }

  Future<void> playSong(Song song) async {
    _currentSong = song;
    final AudioSource source;
    if (song.audioUrl.startsWith('assets/')) {
      source = AudioSource.asset(song.audioUrl);
    } else {
      source = AudioSource.uri(Uri.parse(song.audioUrl));
    }
    await _audioPlayer.setAudioSource(source);
    await _audioPlayer.play();
    notifyListeners();
  }

  Future<void> play() async => await _audioPlayer.play();
  Future<void> pause() async => await _audioPlayer.pause();
  Future<void> seek(Duration position) async => await _audioPlayer.seek(position);
  Future<void> stop() async => await _audioPlayer.stop();
  @override
  Future<void> dispose() async => await _audioPlayer.dispose();

  void closePlayer() {
    _audioPlayer.dispose();
  }
}

// Background handler for audio_service (basic)
class BackgroundAudioHandler extends BaseAudioHandler {
  final AudioPlayerService playerService;

  BackgroundAudioHandler(this.playerService);

  @override
  Future<void> play() => playerService.play();

  @override
  Future<void> pause() => playerService.pause();

  @override
  Future<void> stop() => playerService.stop();
}
