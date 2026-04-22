import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: SongListScreen(),
    );
  }
}

class Song {
  final String title;
  final String artist;
  Song(this.title, this.artist);
}

class SongListScreen extends StatelessWidget {
  final List<Song> songs = [
    Song('Song 1', 'Artist 1'),
    Song('Song 2', 'Artist 2'),
    Song('Song 3', 'Artist 3'),
  ];

  const SongListScreen({super.key});

  // Note: removed 'const' due to non-const 'songs' field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Icon(Icons.music_note, size: 28), SizedBox(width: 8), Text('Music Library')],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.shuffle), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: Icon(Icons.music_note, color: Colors.purple),
            ),
            title: Hero(
              tag: 'song_${song.title}',
              child: Material(
                color: Colors.transparent,
                child: Text(song.title, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NowPlayingScreen(song: song)),
            ),
          );
        },
      ),
    );
  }
}

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  const NowPlayingScreen({super.key, required this.song});

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Album Art
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.deepOrange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Hero(
                tag: 'song_${widget.song.title}',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.music_note, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'song_${widget.song.title}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        widget.song.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.song.artist, style: TextStyle(color: Colors.grey[300], fontSize: 18)),
                  SizedBox(height: 40),
                  // Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0:12', style: TextStyle(color: Colors.grey[400])),
                      Text('3:45', style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.purple,
                      inactiveTrackColor: Colors.grey,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: progress,
                      onChanged: (value) => setState(() => progress = value),
                    ),
                  ),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 40, color: Colors.white),
                        onPressed: () {},
                      ),
                      GestureDetector(
                        onTap: () => setState(() => isPlaying = !isPlaying),
                        child: AnimatedScale(
                          scale: isPlaying ? 1.1 : 1.0,
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 40, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.repeat, color: Colors.grey),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
