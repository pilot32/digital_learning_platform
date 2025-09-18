import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonList extends StatefulWidget {
  const LessonList({super.key, required this.lessons});

  final List<Lesson> lessons;

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Completed', 'In-progress', 'Upcoming'];
    final filtered = widget.lessons.where((lesson) {
      if (_filter == 'All') return true;
      return lesson.status == _filter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: tabs.map((t) {
            final selected = _filter == t;
            return FilterChip(
              selected: selected,
              label: Text(t),
              onSelected: (_) => setState(() => _filter = t),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final lesson = filtered[index];
            return Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${lesson.lesson_order}'),
                ),
                title: Text(lesson.lessonTitle),
                subtitle: Text(lesson.status),
                trailing: Icon(
                  lesson.status == 'completed'
                      ? Icons.check_circle_rounded
                      : lesson.status == 'in-progress'
                          ? Icons.timelapse_rounded
                          : Icons.schedule_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {},
              ),
            );
          },
        )
      ],
    );
  }
}


