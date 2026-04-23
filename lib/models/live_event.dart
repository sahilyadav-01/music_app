class LiveEvent {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final String streamUrl;
  final int viewerCount;
  final bool isLive;

  LiveEvent({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.streamUrl,
    required this.viewerCount,
    this.isLive = true,
  });

  factory LiveEvent.fromJson(Map<String, dynamic> json) {
    return LiveEvent(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      thumbnailUrl: json['thumbnailUrl'],
      streamUrl: json['streamUrl'],
      viewerCount: json['viewerCount'] ?? 0,
      isLive: json['isLive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'thumbnailUrl': thumbnailUrl,
    'streamUrl': streamUrl,
    'viewerCount': viewerCount,
    'isLive': isLive,
  };
}
