# TODO: Fix Song Repeating / Add Playlist Queue

## Plan
1. [x] Rewrite `AudioPlayerService` with `ConcatenatingAudioSource`, skip, loop, playlist index tracking
2. [x] Update `SongTile` to accept playlist context
3. [x] Wire up `NowPlayingBar` skip buttons
4. [x] Wire up `NowPlayingScreen` skip + repeat buttons
5. [x] Pass playlist from `HomeScreen`, `LibraryScreen`, `SearchScreen`
6. [x] Test & verify (analyzer clean — only 2 deprecation infos)

## Files Edited
- `lib/services/audio_player_service.dart` — Full playlist queue with skip/loop
- `lib/widgets/song_tile.dart` — Playlist context support
- `lib/widgets/now_playing_bar.dart` — Working skip buttons
- `lib/screens/now_playing_screen.dart` — Working skip + repeat buttons
- `lib/screens/home_screen.dart` — Passes playlist to tiles/cards
- `lib/screens/library_screen.dart` — Passes playlist to tiles
- `lib/screens/search_screen.dart` — Passes playlist to tiles

---
**Status:** COMPLETE
