import 'package:flutter/material.dart';
import 'subject_detail_screen.dart';
import 'login_screen.dart';
import 'today_lesson_screen.dart';
import 'practice_quiz_screen.dart';
import 'rewards_screen.dart';
import 'settings_screen.dart';
import '../models/student.dart';
import '../models/subject.dart';

class StudentDashboardScreen extends StatefulWidget {
  final Student? currentStudent;
  
  const StudentDashboardScreen({super.key, this.currentStudent});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

// Stream categories
enum StreamCategory {
  science('विज्ञान', Icons.science_rounded, 0xFF9C27B0),
  commerce('कॉमर्स', Icons.business_center_rounded, 0xFF2196F3),
  computer('कंप्यूटर', Icons.computer_rounded, 0xFF4CAF50);
  
  final String displayName;
  final IconData icon;
  final int color;
  
  const StreamCategory(this.displayName, this.icon, this.color);
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StreamCategory _selectedStream;
  
  Map<String, dynamic> _dashboardStats = {};
  List<Subject> _mainSubjects = [];
  List<Subject> _advancedSubjects = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: StreamCategory.values.length, vsync: this);
    _loadDashboardData();
    _selectedStream = StreamCategory.science;
    _tabController.addListener(_handleTabSelection);
  }
  
  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _selectedStream = StreamCategory.values[_tabController.index];
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  List<Subject> _getFilteredSubjects(StreamCategory stream) {
    return _advancedSubjects.where((subject) {
      switch (stream) {
        case StreamCategory.science:
          return subject.category == 'science';
        case StreamCategory.commerce:
          return subject.category == 'commerce';
        case StreamCategory.computer:
          return subject.category == 'computer';
        default:
          return false;
      }
    }).toList();
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard({
    required BuildContext context,
    required Subject subject,
    required VoidCallback onTap,
  }) {
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
                value: 16 / subject.totalLessons,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '16/${subject.totalLessons} पाठ',
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const Spacer(),
                  Text(
                    '${(16 / subject.totalLessons * 100).toInt()}%',
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

  IconData _getIconData(String category) {
    switch (category.toLowerCase()) {
      case 'science':
        return Icons.science_rounded;
      case 'commerce':
        return Icons.business_center_rounded;
      case 'computer':
        return Icons.computer_rounded;
      case 'math':
        return Icons.calculate_rounded;
      case 'hindi':
        return Icons.language_rounded;
      case 'english':
        return Icons.language_rounded;
      case 'sanskrit':
        return Icons.menu_book_rounded;
      case 'social_science':
        return Icons.public_rounded;
      case 'physics':
        return Icons.bolt_rounded;
      case 'chemistry':
        return Icons.science_rounded;
      case 'biology':
        return Icons.eco_rounded;
      case 'mathematics':
        return Icons.calculate_rounded;
      case 'accountancy':
        return Icons.account_balance_wallet_rounded;
      case 'business_studies':
        return Icons.business_center_rounded;
      case 'economics':
        return Icons.attach_money_rounded;
      case 'computer_science':
        return Icons.computer_rounded;
      case 'informatics_practices':
        return Icons.code_rounded;
      case 'artificial_intelligence':
        return Icons.smart_toy_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  void _loadDashboardData() {
    _dashboardStats = {
      'totalProgress': 20,
      'completedLessons': 8,
      'inProgressLessons': 4,
      'upcomingLessons': 12,
      'totalLessons': 24,
    };

    _mainSubjects = [
      Subject(
        subjectName: 'हिंदी',
        description: 'Hindi Language',
        totalLessons: 24,
        category: 'language',
        color: '0xFFE91E63', icon: 'Icons.language_rounded',
      ),
      Subject(
        subjectName: 'अंग्रेजी',
        description: 'English Language',
        totalLessons: 20,
        category: 'language',
        color: '0xFF2196F3', icon: 'Icons.language_rounded',
      ),
      Subject(
        subjectName: 'गणित',
        description: 'Mathematics',
        totalLessons: 28,
        category: 'math',
        color: '0xFF4CAF50', icon: 'Icons.calculate_rounded',
      ),
      Subject(
        subjectName: 'विज्ञान',
        description: 'Science',
        totalLessons: 26,
        category: 'science',
        color: '0xFF9C27B0', icon: 'Icons.science_rounded',
      ),
      Subject(
        subjectName: 'सामाजिक विज्ञान',
        description: 'Social Science',
        totalLessons: 22,
        category: 'social_science',
        color: '0xFFFF9800', icon: 'Icons.public_rounded',
      ),
      Subject(
        subjectName: 'संस्कृत',
        description: 'Sanskrit',
        totalLessons: 18,
        category: 'language',
        color: '0xFF795548', icon: 'Icons.language_rounded',
      ),
    ];
    
    _advancedSubjects = [
      // Science subjects
      Subject(
        subjectName: 'भौतिक विज्ञान',
        description: 'Physics',
        totalLessons: 30,
        category: 'science',
        color: '0xFF9C27B0', icon: 'Icons.science_rounded',
      ),
      Subject(
        subjectName: 'रसायन विज्ञान',
        description: 'Chemistry',
        totalLessons: 28,
        category: 'science',
        color: '0xFF4CAF50', icon: 'Icons.science_rounded',
      ),
      Subject(
        subjectName: 'जीव विज्ञान',
        description: 'Biology',
        totalLessons: 26,
        category: 'science',
        color: '0xFF2196F3', icon: 'Icons.eco_rounded',
      ),
      Subject(
        subjectName: 'गणित',
        description: 'Mathematics',
        totalLessons: 32,
        category: 'science',
        color: '0xFFE91E63', icon: 'Icons.calculate_rounded',
      ),
      // Commerce subjects
      Subject(
        subjectName: 'लेखांकन',
        description: 'Accountancy',
        totalLessons: 24,
        category: 'commerce',
        color: '0xFF2196F3', icon: 'Icons.account_balance_wallet_rounded',
      ),
      Subject(
        subjectName: 'व्यवसाय अध्ययन',
        description: 'Business Studies',
        totalLessons: 22,
        category: 'commerce',
        color: '0xFF4CAF50', icon: 'Icons.business_center_rounded',
      ),
      Subject(
        subjectName: 'अर्थशास्त्र',
        description: 'Economics',
        totalLessons: 26,
        category: 'commerce',
        color: '0xFFFF9800', icon: 'Icons.attach_money_rounded',
      ),
      Subject(
        subjectName: 'गणित',
        description: 'Mathematics',
        totalLessons: 28,
        category: 'commerce',
        color: '0xFFE91E63', icon: 'Icons.calculate_rounded',
      ),
      // Computer subjects
      Subject(
        subjectName: 'कंप्यूटर विज्ञान',
        description: 'Computer Science',
        totalLessons: 30,
        category: 'computer',
        color: '0xFF4CAF50', icon: 'Icons.computer_rounded',
      ),
      Subject(
        subjectName: 'सूचना प्रणाली',
        description: 'Informatics Practices',
        totalLessons: 26,
        category: 'computer',
        color: '0xFF2196F3', icon: 'Icons.code_rounded',
      ),
      Subject(
        subjectName: 'कृत्रिम बुद्धिमत्ता',
        description: 'Artificial Intelligence',
        totalLessons: 28,
        category: 'computer',
        color: '0xFF9C27B0', icon: 'Icons.smart_toy_rounded',
      ),
    ];
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.currentStudent?.profileImageUrl != null
                  ? NetworkImage(widget.currentStudent!.profileImageUrl!)
                  : const AssetImage('assets/images/owl_logo.jpg') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'नमस्ते, ${widget.currentStudent?.name ?? 'छात्र'}!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'आज कुछ नया सीखते हैं',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.green, size: 26),
            onPressed: _handleLogout,
            tooltip: 'लॉगआउट / Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/student_dashboard_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Summary
                  _ProgressSummaryCard(
                    isWide: isWide,
                    stats: _dashboardStats,
                  ),
                  const SizedBox(height: 20),
                  
                  // Quick Actions
                  _QuickActions(isWide: isWide),
                  const SizedBox(height: 20),
                  
                  // Main Subjects Section
                  _SectionHeader(title: 'मुख्य विषय (कक्षा 1-8)'),
                  const SizedBox(height: 12),
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
                      return _buildSubjectCard(
                        context: context,
                        subject: subject,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectDetailScreen(
                                subject: subject,
                                studentId: widget.currentStudent?.studentId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Advanced Education Section
                  _SectionHeader(title: 'उच्च शिक्षा (कक्षा 11-12)'),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          tabs: StreamCategory.values.map((stream) {
                            return Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(stream.icon, size: 18),
                                  const SizedBox(width: 6),
                                  Text(stream.displayName),
                                ],
                              ),
                            );
                          }).toList(),
                          labelColor: theme.colorScheme.primary,
                          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                          indicatorColor: theme.colorScheme.primary,
                          dividerColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Tab Content
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 240),
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: StreamCategory.values.map((stream) {
                            final subjects = _getFilteredSubjects(stream);
                            
                            if (subjects.isEmpty) {
                              return _buildEmptyState(
                                theme,
                                'इस स्ट्रीम में कोई विषय उपलब्ध नहीं है',
                              );
                            }
                            
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: subjects.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isWide ? 3 : 2,
                                mainAxisExtent: 110,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 2.2,
                              ),
                              itemBuilder: (context, index) {
                                final subject = subjects[index];
                                return _buildSubjectCard(
                                  context: context,
                                  subject: subject,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubjectDetailScreen(
                                          subject: subject,
                                          studentId: widget.currentStudent?.studentId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Progress Summary Card Widget
class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.isWide,
    required this.stats,
  });

  final bool isWide;
  final Map<String, dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBadge(
                  icon: Icons.auto_graph_rounded,
                  background: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'आपकी प्रगति',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isWide)
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'पूर्ण',
                      value: '${stats['completedLessons']} पाठ',
                      color: colorScheme.primary,
                      minWidth: 100,
                    ),
                  ),
                  Expanded(
                    child: _SummaryTile(
                      icon: Icons.schedule_rounded,
                      label: 'चालू',
                      value: '${stats['inProgressLessons']} पाठ',
                      color: colorScheme.secondary,
                      minWidth: 100,
                    ),
                  ),
                  Expanded(
                    child: _SummaryTile(
                      icon: Icons.lock_clock_rounded,
                      label: 'आगामी',
                      value: '${stats['upcomingLessons']} पाठ',
                      color: colorScheme.tertiary,
                      minWidth: 100,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _SummaryTile(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'पूर्ण',
                    value: '${stats['completedLessons']} पाठ',
                    color: colorScheme.primary,
                    minWidth: double.infinity,
                  ),
                  const Divider(height: 24),
                  _SummaryTile(
                    icon: Icons.schedule_rounded,
                    label: 'चालू',
                    value: '${stats['inProgressLessons']} पाठ',
                    color: colorScheme.secondary,
                    minWidth: double.infinity,
                  ),
                  const Divider(height: 24),
                  _SummaryTile(
                    icon: Icons.lock_clock_rounded,
                    label: 'आगामी',
                    value: '${stats['upcomingLessons']} पाठ',
                    color: colorScheme.tertiary,
                    minWidth: double.infinity,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (stats['totalProgress'] as int?)?.toDouble() ?? 0 / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${stats['totalProgress']}% पूर्ण',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${stats['completedLessons']}/${stats['totalLessons']} पाठ',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Summary Tile Widget
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
    
    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Row(
        children: [
          _IconBadge(icon: icon, background: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Actions Widget
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

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

// Icon Badge Widget
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
