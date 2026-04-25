# TODO: Add Real Songs and Images

## Plan
1. [x] Examine image loading logic in widgets/screens
2. [x] Create comprehensive `getMockSongs()` with all 24 real local audio files
3. [x] Use existing `saiyaara_cover.jpg` for Saiyaara song
4. [x] Use descriptive placeholder images for songs without real covers
5. [x] Test & verify (file syntax confirmed clean)

## Files Edited
- `lib/services/mock_api_service.dart` — Replaced mock songs with 24 real local audio files

## Notes
- `pubspec.yaml` already includes `assets/images/` and `assets/audio/`
- `Image.asset()` and `CachedNetworkImage()` already support both local and network images
- To add real cover images later, drop `.jpg` files into `assets/images/` and update the `imageUrl` path

---
**Status:** COMPLETE
