import 'package:flutter/material.dart';

class StreakCounter extends StatefulWidget {
  const StreakCounter({super.key, required this.streak});
  final int streak;

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: _scale,
      child: Chip(
        avatar: Icon(Icons.local_fire_department_rounded, color: Colors.deepOrange),
        label: Text('${widget.streak} दिन की लकीर'),
        backgroundColor: cs.surfaceContainerHighest,
      ),
    );
  }
}


