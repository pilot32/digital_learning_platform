import 'package:flutter/material.dart';

class MediaPlayerWidget extends StatefulWidget {
  const MediaPlayerWidget({super.key});

  @override
  State<MediaPlayerWidget> createState() => _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  bool _isPlaying = false;
  double _position = 0.2; // 20% timeline for demo

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 72,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(trackHeight: 4),
                child: Slider(
                  value: _position,
                  onChanged: (v) => setState(() => _position = v),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                    icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.fullscreen_rounded),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


