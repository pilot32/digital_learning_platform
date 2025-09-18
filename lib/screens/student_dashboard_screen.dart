import 'package:flutter/material.dart';
import 'subject_detail_screen.dart';
import 'today_lesson_screen.dart';
import 'practice_quiz_screen.dart';
import 'rewards_screen.dart';
import 'settings_screen.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../database/database_helper.dart';

class StudentDashboardScreen extends StatefulWidget {
  final Student? currentStudent;
  
  const StudentDashboardScreen({super.key, this.currentStudent});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic> _dashboardStats = {};
  List<Subject> _mainSubjects = [];
  List<Subject> _advancedSubjects = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (widget.currentStudent != null) {
      final stats = await _dbHelper.getDashboardStats(widget.currentStudent!.studentId!);
      final mainSubjects = await _dbHelper.getSubjectsByCategory('main');
      final advancedSubjects = await _dbHelper.getSubjectsByCategory('advanced');
      
      setState(() {
        _dashboardStats = stats;
        _mainSubjects = mainSubjects;
        _advancedSubjects = advancedSubjects;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('नमस्ते, ${widget.currentStudent?.name ?? 'छात्र'}!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            Text(
              'आज भी कुछ नया सीखते हैं',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'सेटिंग्स',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/student_dashboard_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _ProgressSummaryCard(
                isWide: isWide,
                stats: _dashboardStats,
              ),
              const SizedBox(height: 16),
              const _SectionHeader(title: 'मुख्य विषय'),
              const SizedBox(height: 8),
              if (!isWide)
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mainSubjects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final subject = _mainSubjects[index];
                      return SizedBox(
                        width: constraints.maxWidth * 0.80,
                        child: SubjectCard(
                          subject: subject,
                          studentId: widget.currentStudent?.studentId,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubjectDetailScreen(
                                  subject: subject,
                                  studentId: widget.currentStudent?.studentId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mainSubjects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 3 : 2,
                    mainAxisExtent: 170,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final subject = _mainSubjects[index];
                    return SubjectCard(
                      subject: subject,
                      studentId: widget.currentStudent?.studentId,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubjectDetailScreen(
                              subject: subject,
                              studentId: widget.currentStudent?.studentId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

              const SizedBox(height: 20),
              const _SectionHeader(title: 'उच्च शिक्षा के लिए तैयारी'),
              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _advancedSubjects.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 4 : 2,
                  childAspectRatio: isWide ? 1.5 : 1.35,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final subject = _advancedSubjects[index];
                  return _AdvancedSubjectCard(
                    subject: subject,
                  );
                },
              ),

              const SizedBox(height: 20),
              const _SectionHeader(title: 'त्वरित कार्य'),
              const SizedBox(height: 8),

              _QuickActions(isWide: isWide),
            ],
          );
        },
      ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    this.studentId,
    this.onTap,
  });

  final Subject subject;
  final int? studentId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = Color(int.parse(subject.color));

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHighest.withOpacity(0.90),
            image: DecorationImage(
              image: AssetImage('assets/images/${subject.subjectName.replaceAll(' ', '_').toLowerCase()}.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.85), BlendMode.srcATop),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBadge(icon: Icons.book, background: color),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      '${subject.totalLessons} पाठ',
                      style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onPrimaryContainer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                subject.subjectName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subject.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: 0.5, // TODO: Calculate actual progress
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '0/${subject.totalLessons} पाठ',
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const Spacer(),
                  Text(
                    '0%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({required this.isWide, required this.stats});

  final bool isWide;
  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalProgress = stats['totalProgress'] ?? 0;
    final completedLessons = stats['completedLessons'] ?? 0;
    final progressPercentage = totalProgress > 0 ? (completedLessons / totalProgress * 100).round() : 0;
    
    final items = [
      ('$progressPercentage%', 'कुल प्रगति', Icons.show_chart_rounded, colorScheme.primary),
      ('${stats['streakDays'] ?? 0}', 'दिन की लकीर', Icons.local_fire_department_rounded, Colors.deepOrange),
      ('${stats['totalStars'] ?? 0}', 'कुल तारे', Icons.star_rounded, Colors.amber),
      ('${stats['badgesEarned'] ?? 0}', 'बैज अर्जित', Icons.verified_rounded, Colors.teal),
    ];

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (context, c) {
          final wrap = Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 12,
            spacing: 12,
            children: items
                .map(
                  (e) => _SummaryTile(
                    value: e.$1,
                    label: e.$2,
                    icon: e.$3,
                    color: e.$4,
                    minWidth: isWide ? 180 : (c.maxWidth - 12) / 2,
                  ),
                )
                .toList(),
          );
          return wrap;
        }),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.minWidth,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedSubjectCard extends StatelessWidget {
  const _AdvancedSubjectCard({
    required this.subject,
  });

  final Subject subject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = Color(int.parse(subject.color));

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBadge(icon: Icons.book, background: color),
            const SizedBox(height: 10),
            Text(
              subject.subjectName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subject.description,
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: 0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '0/${subject.totalLessons} पाठ',
                  style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  '0%',
                  style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final actions = [
      ('आज का पाठ', Icons.today_rounded, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TodayLessonScreen()));
      }),
      ('अभ्यास प्रश्न', Icons.quiz_rounded, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeQuizScreen()));
      }),
      ('पुरस्कार देखें', Icons.emoji_events_rounded, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardsScreen()));
      }),
      ('सेटिंग्स', Icons.settings_rounded, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
      }),
    ];

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 12,
          spacing: 12,
          children: actions.map((a) {
            return SizedBox(
              width: isWide
                  ? 220
                  : (MediaQuery.of(context).size.width - 16 * 2 - 12 * 1) / 2,
              child: FilledButton.tonalIcon(
                onPressed: a.$3 as void Function(),
                icon: Icon(a.$2),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    a.$1,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.background});
  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: background.withOpacity(0.15),
      child: Icon(icon, size: 20, color: background),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}


