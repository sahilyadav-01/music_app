class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final Duration duration;
  final bool isLive;
  final int plays;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
    this.isLive = false,
    this.plays = 0,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      duration: Duration(seconds: json['duration'] ?? 180),
      isLive: json['isLive'] ?? false,
      plays: json['plays'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'album': album,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'duration': duration.inSeconds,
    'isLive': isLive,
    'plays': plays,
  };
}
