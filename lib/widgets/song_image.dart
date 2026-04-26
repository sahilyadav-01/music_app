import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/song.dart';
import '../services/image_service.dart';

class SongImage extends StatelessWidget {
  final Song song;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SongImage({
    super.key,
    required this.song,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Local assets load directly without network
    if (song.imageUrl.startsWith('assets/')) {
      return Image.asset(song.imageUrl, fit: fit, width: width, height: height);
    }

    return FutureBuilder<String>(
      future: ImageService.getCoverUrl(song),
      builder: (context, snapshot) {
        final url = snapshot.data ?? song.imageUrl;

        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          width: width,
          height: height,
          placeholder: (context, url) => _placeholder(context),
          errorWidget: (context, url, error) => _placeholder(context),
        );
      },
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: song.isLive ? Colors.red : Colors.deepPurple,
      child: const Icon(Icons.music_note, color: Colors.white),
    );
  }
}
