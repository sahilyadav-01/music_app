import 'dart:math';
import '../models/song.dart';
import '../models/live_event.dart';

class MockApiService {
  static List<Song> getMockSongs() {
    return [
      // Western Hits
      Song(
        id: '1',
        title: 'Bohemian Rhapsody',
        artist: 'Queen',
        album: 'A Night at the Opera',
        imageUrl: 'https://via.placeholder.com/300x300/6f42c1/ffffff?text=Queen',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        duration: Duration(minutes: 6, seconds: 4),
      ),
      Song(
        id: '2',
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        album: '÷',
        imageUrl: 'https://via.placeholder.com/300x300/ff6b6b/ffffff?text=Ed+Sheeran',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        duration: Duration(minutes: 3, seconds: 53),
      ),
      Song(
        id: '3',
        title: 'Hotel California',
        artist: 'Eagles',
        album: 'Hotel California',
        imageUrl: 'https://via.placeholder.com/300x300/ffd43b/000000?text=Eagles',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        duration: Duration(minutes: 6, seconds: 30),
      ),
      Song(
        id: '4',
        title: 'Billie Jean',
        artist: 'Michael Jackson',
        album: 'Thriller',
        imageUrl: 'https://via.placeholder.com/300x300/ff4444/ffffff?text=MJ',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        duration: Duration(minutes: 4, seconds: 54),
      ),
      Song(
        id: '5',
        title: 'Smells Like Teen Spirit',
        artist: 'Nirvana',
        album: 'Nevermind',
        imageUrl: 'https://via.placeholder.com/300x300/4a90e2/ffffff?text=Nirvana',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        duration: Duration(minutes: 5, seconds: 1),
      ),
      Song(
        id: '6',
        title: 'Rolling in the Deep',
        artist: 'Adele',
        album: '21',
        imageUrl: 'https://via.placeholder.com/300x300/f39c12/ffffff?text=Adele',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        duration: Duration(minutes: 3, seconds: 48),
      ),
      Song(
        id: '7',
        title: 'Uptown Funk',
        artist: 'Mark Ronson ft. Bruno Mars',
        album: 'Uptown Special',
        imageUrl: 'https://via.placeholder.com/300x300/e91e63/ffffff?text=Uptown',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        duration: Duration(minutes: 4, seconds: 30),
      ),
      Song(
        id: '8',
        title: 'Bad Guy',
        artist: 'Billie Eilish',
        album: 'When We All Fall Asleep',
        imageUrl: 'https://via.placeholder.com/300x300/9c27b0/ffffff?text=Billie',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        duration: Duration(minutes: 3, seconds: 14),
      ),
      // Hindi Songs
      Song(
        id: '9',
        title: 'Tum Hi Ho',
        artist: 'Arijit Singh',
        album: 'Aashiqui 2',
        imageUrl: 'https://via.placeholder.com/300x300/ff9800/ffffff?text=Arijit',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
        duration: Duration(minutes: 4, seconds: 21),
      ),
      Song(
        id: '10',
        title: 'Raabta',
        artist: 'Arijit Singh',
        album: 'Agent Vinod',
        imageUrl: 'https://via.placeholder.com/300x300/f44336/ffffff?text=Raabta',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
        duration: Duration(minutes: 4, seconds: 47),
      ),
      Song(
        id: '11',
        title: 'Kala Chashma',
        artist: 'Badshah, Neha Kakkar',
        album: 'Baar Baar Dekho',
        imageUrl: 'https://via.placeholder.com/300x300/00bcd4/ffffff?text=Kala+Chashma',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
        duration: Duration(minutes: 4, seconds: 24),
      ),
      // Punjabi
      Song(
        id: '12',
        title: 'Proper Patola',
        artist: 'Diljit Dosanjh, Badshah',
        album: 'Namaste England',
        imageUrl: 'https://via.placeholder.com/300x300/9c27b0/ffffff?text=Diljit',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
        duration: Duration(minutes: 3, seconds: 32),
      ),
      Song(
        id: '13',
        title: 'Lamberghini',
        artist: 'Guru Randhawa',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/607d8b/ffffff?text=Guru',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
        duration: Duration(minutes: 3, seconds: 10),
      ),
      Song(
        id: '14',
        title: 'High Rated Gabru',
        artist: 'Guru Randhawa',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/795548/ffffff?text=High+Rated',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
        duration: Duration(minutes: 3, seconds: 2),
      ),
      Song(
        id: '15',
        title: '2 AM',
        artist: 'Guru Randhawa, Bohemia',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/e91e63/ffffff?text=2+AM',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
        duration: Duration(minutes: 3, seconds: 49),
      ),
      // Haryanvi
      Song(
        id: '16',
        title: 'Made In India (Haryanvi Beat)',
        artist: 'Ruchika Jangid',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/ff5722/ffffff?text=Ruchika',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3',
        duration: Duration(minutes: 3, seconds: 30),
      ),
      Song(
        id: '17',
        title: '2 Number',
        artist: 'Ndee Kundu',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/9e9e9e/ffffff?text=Ndee',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3',
        duration: Duration(minutes: 3, seconds: 45),
      ),
    ];
  }

  static List<Song> getLiveSongs() {
    return [
          LiveEvent(
            id: 'live1',
            title: 'Rock Festival Live',
            artist: 'Live Band',
            thumbnailUrl: 'https://via.placeholder.com/400x225/ff0000/ffffff?text=LIVE+Rock',
            streamUrl: 'http://stream.zeno.fm/0r0xa8m8kxxuv',
            viewerCount: Random().nextInt(10000) + 1000,
          ),
          // ... rest live events as before
        ]
        .map(
          (e) => Song(
            id: e.id,
            title: e.title,
            artist: e.artist,
            album: 'Live',
            imageUrl: e.thumbnailUrl,
            audioUrl: e.streamUrl,
            duration: Duration.zero,
            isLive: true,
          ),
        )
        .toList();
  }

  static List<LiveEvent> getLiveEvents() {
    final r = Random().nextInt(20000) + 1000;
    return [
      LiveEvent(
        id: 'live1',
        title: 'Rock Festival Live',
        artist: 'Live Band',
        thumbnailUrl: 'https://via.placeholder.com/400x225/ff0000/ffffff?text=LIVE+Rock',
        streamUrl: 'http://stream.zeno.fm/0r0xa8m8kxxuv',
        viewerCount: r,
      ),
      LiveEvent(
        id: 'live2',
        title: 'Jazz Night',
        artist: 'Jazz Masters',
        thumbnailUrl: 'https://via.placeholder.com/400x225/4169e1/ffffff?text=LIVE+Jazz',
        streamUrl: 'http://ice1.somafm.com/groove-128-mp3',
        viewerCount: r ~/ 2,
      ),
      LiveEvent(
        id: 'live3',
        title: 'EDM Party Live',
        artist: 'DJ Party',
        thumbnailUrl: 'https://via.placeholder.com/400x225/00bcd4/ffffff?text=LIVE+EDM',
        streamUrl: 'http://stream.zeno.fm/9m9xnn8r7ktxr',
        viewerCount: r ~/ 3,
      ),
      LiveEvent(
        id: 'live4',
        title: 'Classical Live',
        artist: 'Orchestra',
        thumbnailUrl: 'https://via.placeholder.com/400x225/795548/ffffff?text=LIVE+Classical',
        streamUrl: 'http://ice1.somafm.com/sector70-128-mp3',
        viewerCount: r ~/ 4,
      ),
      LiveEvent(
        id: 'live5',
        title: 'Pop Live Hits',
        artist: 'Top 40',
        thumbnailUrl: 'https://via.placeholder.com/400x225/e91e63/ffffff?text=LIVE+Pop',
        streamUrl: 'http://stream.zeno.fm/ak8r7rn93zuv',
        viewerCount: r ~/ 1.5,
      ),
      LiveEvent(
        id: 'live6',
        title: 'Hindi Live Show',
        artist: 'Bollywood DJ',
        thumbnailUrl: 'https://via.placeholder.com/400x225/ff9800/000?text=LIVE+Hindi',
        streamUrl: 'http://stream.zeno.fm/xxxxxx',
        viewerCount: r ~/ 2.5,
      ), // Placeholder
    ];
  }

  static Future<List<Song>> searchSongs(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final songs = getMockSongs();
    return songs
        .where(
          (s) =>
              s.title.toLowerCase().contains(query.toLowerCase()) ||
              s.artist.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
