import 'package:flutter/material.dart';

class TodayLessonScreen extends StatefulWidget {
  const TodayLessonScreen({super.key});

  @override
  State<TodayLessonScreen> createState() => _TodayLessonScreenState();
}

class _TodayLessonScreenState extends State<TodayLessonScreen> {
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('आज का पाठ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('विषय: अंग्रेज़ी - पाठ 12'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: _progress, minHeight: 8, borderRadius: BorderRadius.circular(8)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${(_progress * 100).round()}% पूर्ण'),
                      const Spacer(),
                      FilledButton(
                        onPressed: () => setState(() => _progress = (_progress + 0.1).clamp(0.0, 1.0)),
                        child: const Text('आगे बढ़ें'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('पाठ सामग्री', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('यहाँ पर आज के पाठ की सामग्री का विवरण होगा। यह डमी टेक्स्ट है।')
        ],
      ),
    );
  }
}


