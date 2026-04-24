# UI Revamp TODO

## Plan Approved: Apply all UI changes

- [x] 1. `lib/main.dart` — Unify theme colors (deep purple primary + amber accent), fix BottomNavigationBar.
- [x] 2. `lib/screens/now_playing_screen.dart` — Square album art, better gradient, improved controls, favorite toggle.
- [x] 3. `lib/widgets/now_playing_bar.dart` — Progress bar, tap-to-expand, fix icons, better layout.
- [x] 4. `lib/widgets/song_tile.dart` — Custom row design, playing indicator, better spacing.
- [x] 5. `lib/screens/home_screen.dart` — Horizontal carousels, improved SliverAppBar, section headers.
- [x] 6. `lib/screens/live_screen.dart` — Better cards, image scrim, improved typography.
- [x] 7. `lib/screens/library_screen.dart` — Category chips, polished list, headers.
- [x] 8. `lib/screens/search_screen.dart` — Transparent AppBar, empty state, icons in TextField.

## Verification
- [x] `flutter analyze` — only pre-existing issues in `audio_player_service.dart` remain (no new issues introduced).

