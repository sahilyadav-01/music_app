import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_player_service.dart';

class MusicVisualizer extends StatefulWidget {
  const MusicVisualizer({super.key});

  @override
  _MusicVisualizerState createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _bars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
      ..repeat();
    _bars = List.generate(20, (i) => 0.2 + 0.3 * (i % 4) / 4);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<AudioPlayerService>();
    final position =
        player.position.inMilliseconds / player.duration.inMilliseconds.clamp(1, double.infinity);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final time = _controller.value;
        return CustomPaint(
          size: Size(double.infinity, 8),
          painter: VisualizerPainter(_bars, position, time),
        );
      },
    );
  }
}

class VisualizerPainter extends CustomPainter {
  final List<double> bars;
  final double position;
  final double time;

  VisualizerPainter(this.bars, this.position, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / bars.length;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < bars.length; i++) {
      final barHeight = bars[i] * 8 + (time * 0.1 * (i % 3 + 1)).remainder(1.0) * 4;
      final x = i * barWidth;

      // Gradient color based on position
      final hue = (position * 360 + i * 10) % 360;
      paint.color = HSVColor.fromAHSV(1.0, hue / 360, 0.8, 0.6 + barHeight / 12).toColor();

      canvas.drawRect(Rect.fromLTWH(x, size.height - barHeight, barWidth * 0.8, barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
