import 'dart:math';
import '../models/song.dart';
import '../models/live_event.dart';

class MockApiService {
  static List<Song> getMockSongs() {
    return [
      // --- Real Local Songs ---
      Song(
        id: 'real1',
        title: 'Tum Ho Toh',
        artist: 'Vishal Mishra, Hansika Pareek',
        album: 'Saiyaara',
        imageUrl: 'assets/images/saiyaara_cover.jpg',
        audioUrl:
            'assets/audio/Tum Ho Toh Song _ Saiyaara _ Ahaan Panday, Aneet Padda _ Vishal Mishra, Hansika Pareek _ Raj Shekhar.mp3',
        duration: Duration(minutes: 3, seconds: 30),
      ),
      Song(
        id: 'real2',
        title: 'Lambiyaan Si Judaiyaan',
        artist: 'Arijit Singh',
        album: 'Raabta',
        imageUrl: 'https://via.placeholder.com/300x300/4a148c/ffffff?text=Lambiyaan+Si+Judaiyaan',
        audioUrl:
            'assets/audio/Arijit_Singh___Lambiyaan_Si_Judaiyaan_With_Lyrics___Raabta___Sushant_Rajput,_Kriti_Sanon___T-Series(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 58),
      ),
      Song(
        id: 'real3',
        title: 'Baarish Ban Jana',
        artist: 'Stebin Ben, Payal Dev',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/1565c0/ffffff?text=Baarish+Ban+Jana',
        audioUrl: 'assets/audio/Baarish Ban Jana(KoshalWorld.Com).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 12),
      ),
      Song(
        id: 'real4',
        title: 'Bairi',
        artist: 'Virat, Miss Parul',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/b71c1c/ffffff?text=Bairi',
        audioUrl:
            'assets/audio/Bairi__Official_Video__Virat,_Miss_Parul___Pradeep_Solanki,_Heena___New_Rajasthani_Song_2026(48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 5),
      ),
      Song(
        id: 'real5',
        title: 'Balkan Girl',
        artist: 'Dhanda Nyoliwala, Xvir Grewal',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/00695c/ffffff?text=Balkan+Girl',
        audioUrl:
            'assets/audio/Balkan_Girl__Official_Music_Video__Dhanda_Nyoliwala___Xvir_Grewal(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 45),
      ),
      Song(
        id: 'real6',
        title: 'Banjaara',
        artist: 'Mohammed Irfan',
        album: 'Ek Villain',
        imageUrl: 'https://via.placeholder.com/300x300/283593/ffffff?text=Banjaara',
        audioUrl: 'assets/audio/Banjaara(48k).mp3.mpeg',
        duration: Duration(minutes: 5, seconds: 2),
      ),
      Song(
        id: 'real7',
        title: 'Bau Ji',
        artist: 'Mohit Ladhotiya',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/e65100/ffffff?text=Bau+Ji',
        audioUrl:
            'assets/audio/Bau_Ji__Official_Video__Mohit_Ladhotiya___Fiza_Choudhary___New_Haryanvi_Song_2026___Nav_Haryanvi(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 35),
      ),
      Song(
        id: 'real8',
        title: 'Financer',
        artist: 'Bintu Pabra',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/2e7d32/ffffff?text=Financer',
        audioUrl:
            'assets/audio/Financer_-_Bintu_Pabra___Pranjal_Dahiya___Shiva_Choudhary___Gunde_Bhi_Financer_Bhi(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 40),
      ),
      Song(
        id: 'real9',
        title: 'Koi Aaye Na Rabba',
        artist: 'B Praak',
        album: 'Daaka',
        imageUrl: 'https://via.placeholder.com/300x300/6a1b9a/ffffff?text=Koi+Aaye+Na+Rabba',
        audioUrl:
            'assets/audio/Full_Video__Koi_Aaye_Na_Rabba___DAAKA___Gippy_Grewal,_Zareen_Khan___Rochak_Feat._B_Praak___Kumaar(48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 15),
      ),
      Song(
        id: 'real10',
        title: 'Heart Break Song',
        artist: 'Unknown Artist',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/ad1457/ffffff?text=Heart+Break+Song',
        audioUrl: 'assets/audio/heart beack song.mpeg',
        duration: Duration(minutes: 3, seconds: 30),
      ),
      Song(
        id: 'real11',
        title: 'Ijazat (Cover)',
        artist: 'Nehaal Naseem',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/4527a0/ffffff?text=Ijazat+Cover',
        audioUrl: 'assets/audio/Ijazat___Cover___Nehaal_Naseem___FalakShabir__(48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 0),
      ),
      Song(
        id: 'real12',
        title: 'Jitni Dafa',
        artist: 'Jeet Gannguli',
        album: 'Parmanu',
        imageUrl: 'https://via.placeholder.com/300x300/c62828/ffffff?text=Jitni+Dafa',
        audioUrl:
            'assets/audio/Jitni_Dafa_-_Lyrical___PARMANU___John_Abraham_,_Diana___Jeet_Gannguli___RashmiVirag(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 50),
      ),
      Song(
        id: 'real13',
        title: 'Kahani Suno 2.0',
        artist: 'Kaifi Khalil',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/1565c0/ffffff?text=Kahani+Suno+2.0',
        audioUrl:
            'assets/audio/Kaifi_Khalil_-_Kahani_Suno_2.0_[Official_Music_Video](48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 28),
      ),
      Song(
        id: 'real14',
        title: 'Main Woh Chaand',
        artist: 'Himesh Reshammiya',
        album: 'Teraa Surroor',
        imageUrl: 'https://via.placeholder.com/300x300/4a148c/ffffff?text=Main+Woh+Chaand',
        audioUrl:
            'assets/audio/MAIN_WOH_CHAAND_Full_Video_Song___TERAA_SURROOR___Himesh_Reshammiya,_Farah_Karimaee___T-Series(48k).mp3.mpeg',
        duration: Duration(minutes: 5, seconds: 10),
      ),
      Song(
        id: 'real15',
        title: 'Na Jaiye Meri Desi Look Pe',
        artist: 'Unknown Artist',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/2e7d32/ffffff?text=Desi+Look',
        audioUrl: 'assets/audio/Na Jaiye Meri Desi Look Pe-(PagalSongs.Com.IN).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 45),
      ),
      Song(
        id: 'real16',
        title: 'Raaz Aankhein Teri',
        artist: 'Arijit Singh',
        album: 'Raaz Reboot',
        imageUrl: 'https://via.placeholder.com/300x300/880e4f/ffffff?text=Raaz+Aankhein+Teri',
        audioUrl:
            'assets/audio/RAAZ_AANKHEIN_TERI__Lyrical_Video_Song___Raaz_Reboot___Arijit_Singh___Emraan_Hashmi,_Kriti_Kharbanda(48k).mp3.mpeg',
        duration: Duration(minutes: 5, seconds: 5),
      ),
      Song(
        id: 'real17',
        title: 'Ranjha 2',
        artist: 'Simar Dorraha',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/d84315/ffffff?text=Ranjha+2',
        audioUrl:
            'assets/audio/Ranjha_2_[Official_MV]_Simar_Dorraha_Ft._Twinkle_Mahajann_-_Gezzy_-_BOP_Music(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 55),
      ),
      Song(
        id: 'real18',
        title: 'Sara Pind',
        artist: 'Bittu Buttar, Kirat Sidhu',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/006064/ffffff?text=Sara+Pind',
        audioUrl:
            'assets/audio/Sara_Pind__Official_Visuals__–_Bittu_Buttar_x_Kirat_Sidhu___Hide_Beats___New_Punjabi_Song_2025(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 48),
      ),
      Song(
        id: 'real19',
        title: 'Scorpio',
        artist: 'Akash Dixit, Sunny Yaduvanshi',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/1b5e20/ffffff?text=Scorpio',
        audioUrl:
            'assets/audio/Scorpio__Official_Video__-_Akash_Dixit___Sunny_Yaduvanshi___New_Haryanvi_Song_2026___Flame_Music(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 42),
      ),
      Song(
        id: 'real20',
        title: 'Tere Bina',
        artist: 'Arijit Singh',
        album: '1921',
        imageUrl: 'https://via.placeholder.com/300x300/311b92/ffffff?text=Tere+Bina',
        audioUrl:
            'assets/audio/Tere_Bina__Lyrical__-_Arijit_Singh___Zareen_Khan___Karan_Kundrra___Aakanksha_S___Asad_Khan___1921(48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 30),
      ),
      Song(
        id: 'real21',
        title: 'Teri Yaadon Mein',
        artist: 'Unknown Artist',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/4e342e/ffffff?text=Teri+Yaadon+Mein',
        audioUrl: 'assets/audio/Teri Yaadon Mein(PagalWorld).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 10),
      ),
      Song(
        id: 'real22',
        title: 'Thoda Thoda Pyaar',
        artist: 'Stebin Ben',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/c62828/ffffff?text=Thoda+Thoda+Pyaar',
        audioUrl:
            'assets/audio/Thoda_Thoda_Pyaar___Sidharth_Malhotra___Neha_Sharma___Stebin_Ben,_Nilesh_Ahuja,_Kumaar___Lyrical(48k).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 5),
      ),
      Song(
        id: 'real23',
        title: 'Tu Samne Baitha Rahe (Female)',
        artist: 'Unknown Artist',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/263238/ffffff?text=Tu+Samne+Baitha+Rahe',
        audioUrl:
            'assets/audio/Tu Samne Baitha Rahe Tujhe Dekha Karu Raat Din (Female Version)-(PagalSongs.Com.IN).mp3.mpeg',
        duration: Duration(minutes: 4, seconds: 20),
      ),
      Song(
        id: 'real24',
        title: 'Veham',
        artist: 'Chayan',
        album: 'Single',
        imageUrl: 'https://via.placeholder.com/300x300/3e2723/ffffff?text=Veham',
        audioUrl: 'assets/audio/Veham_-_Chayan__Official_Audio_(48k).mp3.mpeg',
        duration: Duration(minutes: 3, seconds: 38),
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
