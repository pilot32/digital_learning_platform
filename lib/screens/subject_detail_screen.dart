import 'package:flutter/material.dart';
import '../widgets/media_player_widget.dart';
import '../widgets/lesson_list.dart';
import '../models/subject.dart';
import '../models/lesson.dart';
import '../database/database_helper.dart';

class SubjectDetailScreen extends StatefulWidget {
  const SubjectDetailScreen({super.key, required this.subject, this.studentId});

  final Subject subject;
  final int? studentId;

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Lesson> _lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final lessons = await _dbHelper.getLessonsBySubject(widget.subject.subjectId!);
    setState(() {
      _lessons = lessons;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.subject;

    return Scaffold(
      appBar: AppBar(
        title: Text('${s.subjectName} / ${s.description}'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final content = [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('पाठ विवरण', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatChip(icon: Icons.task_alt_rounded, label: 'पूर्ण', value: '0'),
                      const SizedBox(width: 8),
                      _StatChip(icon: Icons.pending_actions_rounded, label: 'शेष', value: '${s.totalLessons}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LessonList(lessons: _lessons),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('प्लेयर', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const MediaPlayerWidget(),
                ],
              ),
            ),
          ),
        ];

        if (isWide) {
          return Row(children: content);
        }
        return Column(children: content);
      }),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon),
      label: Text('$label: $value'),
    );
  }
}


