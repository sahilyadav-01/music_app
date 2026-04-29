import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import 'download_service.dart';

class AudioHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
  final AudioPlayer _player = AudioPlayer();
  final DownloadService? _downloadService;

  AudioHandler(this._downloadService) {
    // Playback event listener
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playbackState.value.playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          processingState: _getProcessingState(event.processingState),
          updatePosition: event.updatePosition,
          bufferedPosition: event.bufferedPosition,
          speed: 1.0,
        ),
      );
    });
  }

  AudioProcessingState _getProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> playPlaylist(List<Song> songs, {int startIndex = 0}) async {
    final playlist = songs.map((song) {
      final url = _downloadService?.getAudioUrl(song) ?? song.audioUrl;
      AudioSource source;
      if (url.startsWith('assets/')) {
        source = AudioSource.asset(url);
      } else if (url.startsWith('file://') ||
          url.contains(RegExp(r'^[a-zA-Z]:\\')) ||
          url.startsWith('/')) {
        source = AudioSource.uri(Uri.file(url));
      } else {
        source = AudioSource.uri(Uri.parse(url));
      }
      return source;
    }).toList();

    await _player.setAudioSources(playlist, initialIndex: startIndex);
    await _player.play();

    // Update queue with MediaItems
    final mediaItems = songs
        .map(
          (song) => MediaItem(
            id: song.id,
            title: song.title,
            artist: song.artist,
            artUri: Uri.parse(song.imageUrl),
            duration: song.duration,
            extras: song.toJson(),
          ),
        )
        .toList();

    queue.add(mediaItems);
  }

  Future<void> playSong(Song song) async {
    await playPlaylist([song]);
  }

  @override
  Future<void> onPlay() async => await _player.play();

  @override
  Future<void> onPause() async => await _player.pause();

  @override
  Future<void> onSeek(Duration position) async => await _player.seek(position);

  @override
  Future<void> onSkipToNext() async => await _player.seekToNext();

  @override
  Future<void> onSkipToPrevious() async => await _player.seekToPrevious();

  @override
  Future<void> onUpdateQueue(List<MediaItem> queueItems) async {
    // Update internal queue from MediaItems
    final songs = queueItems.map((item) => Song.fromJson(item.extras ?? {})).toList();
    await playPlaylist(songs);
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
    super.onTaskRemoved();
  }
}
