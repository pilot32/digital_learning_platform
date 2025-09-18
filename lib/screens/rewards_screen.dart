import 'package:flutter/material.dart';
import '../widgets/reward_badge.dart';
import '../widgets/streak_counter.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('पुरस्कार')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  RewardBadge(icon: Icons.star_rounded, label: 'तारे: 127', color: Colors.amber),
                  SizedBox(width: 16),
                  RewardBadge(icon: Icons.verified_rounded, label: 'बैज: 5', color: Colors.teal),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const StreakCounter(streak: 15),
          const SizedBox(height: 16),
          Text('लकीर इतिहास', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              15,
              (i) => Icon(
                Icons.local_fire_department_rounded,
                color: i < 15 ? Colors.deepOrange : cs.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


