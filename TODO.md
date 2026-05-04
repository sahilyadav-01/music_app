# Now Playing Fixes Progress

## Completed
- [x] Bar layout adjustment (height/spacing)
- [x] Screen fit/scrolling  
- [x] Responsive padding/album size
- [x] Image Scroll Fix (now_playing_screen.dart): Wrapped with LayoutBuilder + ConstrainedBox (maxHeight 70%), albumSize clamped to constraints.maxHeight * 0.45, AspectRatio 1:1 on SongImage for square/centered image always visible.

## Next Steps
- [ ] Implement web download in lib/services/download_service.dart (TODO: Web download via anchor tag)
- [ ] Add lyrics support
- [ ] Improve queue management

