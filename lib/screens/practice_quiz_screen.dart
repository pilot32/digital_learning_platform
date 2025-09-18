import 'package:flutter/material.dart';

class PracticeQuizScreen extends StatefulWidget {
  const PracticeQuizScreen({super.key});

  @override
  State<PracticeQuizScreen> createState() => _PracticeQuizScreenState();
}

class _PracticeQuizScreenState extends State<PracticeQuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'भारत की राजधानी क्या है?',
      'options': ['मुंबई', 'दिल्ली', 'कोलकाता', 'चेन्नई'],
      'answer': 1,
    },
    {
      'q': '2 + 2 = ?',
      'options': ['3', '4', '5', '6'],
      'answer': 1,
    },
  ];

  int _index = 0;
  int? _selected;
  int _score = 0;

  void _next() {
    if (_selected == _questions[_index]['answer']) {
      _score++;
    }
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('परिणाम'),
          content: Text('स्कोर: $_score/${_questions.length}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ठीक है'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('अभ्यास प्रश्न')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('प्रश्न ${_index + 1}/${_questions.length}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(q['q'] as String, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...List.generate((q['options'] as List).length, (i) {
              final opt = q['options'][i];
              return Card(
                child: RadioListTile<int>(
                  value: i,
                  groupValue: _selected,
                  onChanged: (v) => setState(() => _selected = v),
                  title: Text(opt as String),
                ),
              );
            }),
            const Spacer(),
            FilledButton(
              onPressed: _selected == null ? null : _next,
              child: const Text('आगे'),
            )
          ],
        ),
      ),
    );
  }
}


