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
    _selectedStream = StreamCategory.science;
    _tabController.addListener(_handleTabSelection);
    _loadDashboardData();
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
    // Navigate back to login screen and remove all previous routes
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
      }
    }).toList();
  }

  // Build empty state widget
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

  // Build subject card widget
  Widget _buildSubjectCard({
    required BuildContext context,
    required Subject subject,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color color = Color(int.parse(subject.color));
    
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHighest,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconData(subject.icon),
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subject.subjectName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0,
                minHeight: 4,
                backgroundColor: colorScheme.surfaceVariant,
                color: color,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0/${subject.totalLessons} पाठ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '0%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
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

  // Helper method to get icon data from string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'Icons.science_rounded':
        return Icons.science_rounded;
      case 'Icons.eco_rounded':
        return Icons.eco_rounded;
      case 'Icons.business_center_rounded':
        return Icons.business_center_rounded;
      case 'Icons.computer_rounded':
        return Icons.computer_rounded;
      case 'Icons.language':
        return Icons.language;
      case 'Icons.calculate_rounded':
        return Icons.calculate_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  void _loadDashboardData() {
    // Mock data for demonstration
    _dashboardStats = {
      'totalProgress': 20,
      'completedLessons': 8,
      'streakDays': 15,
      'totalStars': 127,
      'badgesEarned': 5,
    };
    
    // Main subjects (primary)
    _mainSubjects = [
      Subject(
        subjectName: 'हिंदी',
        description: 'Hindi Language',
        totalLessons: 15,
        category: 'main',
        icon: 'Icons.language',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'अंग्रेज़ी',
        description: 'English Language',
        totalLessons: 20,
        category: 'main',
        icon: 'Icons.language',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'गणित',
        description: 'Mathematics',
        totalLessons: 25,
        category: 'main',
        icon: 'Icons.calculate_rounded',
        color: '0xFF66BB6A',
      ),
    ];

    // Advanced subjects with stream categories
    _advancedSubjects = [
      // Science subjects
      Subject(
        subjectName: 'भौतिक विज्ञान',
        description: 'Physics',
        totalLessons: 30,
        category: 'science',
        icon: 'Icons.science_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'रसायन विज्ञान',
        description: 'Chemistry',
        totalLessons: 28,
        category: 'science',
        icon: 'Icons.science_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'जीव विज्ञान',
        description: 'Biology',
        totalLessons: 32,
        category: 'science',
        icon: 'Icons.eco_rounded',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'गणित',
        description: 'Mathematics',
        totalLessons: 35,
        category: 'science',
        icon: 'Icons.calculate_rounded',
        color: '0xFF2196F3',
      ),
      // Commerce subjects
      Subject(
        subjectName: 'लेखांकन',
        description: 'Accountancy',
        totalLessons: 25,
        category: 'commerce',
        icon: 'Icons.calculate_rounded',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'व्यवसाय अध्ययन',
        description: 'Business Studies',
        totalLessons: 20,
        category: 'commerce',
        icon: 'Icons.business_rounded',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'अर्थशास्त्र',
        description: 'Economics',
        totalLessons: 22,
        category: 'commerce',
        icon: 'Icons.trending_up_rounded',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'सांख्यिकी',
        description: 'Statistics',
        totalLessons: 18,
        category: 'commerce',
        icon: 'Icons.bar_chart_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'बैंकिंग',
        description: 'Banking',
        totalLessons: 20,
        category: 'commerce',
        icon: 'Icons.account_balance_rounded',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'वित्तीय प्रबंधन',
        description: 'Financial Management',
        totalLessons: 24,
        category: 'commerce',
        icon: 'Icons.attach_money_rounded',
        color: '0xFFFFC107',
      ),
      Subject(
        subjectName: 'विपणन प्रबंधन',
        description: 'Marketing Management',
        totalLessons: 22,
        category: 'commerce',
        icon: 'Icons.analytics_rounded',
        color: '0xFFFF5722',
      ),
      Subject(
        subjectName: 'कराधान',
        description: 'Taxation',
        totalLessons: 20,
        category: 'commerce',
        icon: 'Icons.receipt_long_rounded',
        color: '0xFF9C27B0',
      ),
      // Computer subjects
      Subject(
        subjectName: 'कंप्यूटर विज्ञान',
        description: 'Computer Science',
        totalLessons: 30,
        category: 'computer',
        icon: 'Icons.computer_rounded',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'प्रोग्रामिंग',
        description: 'Programming',
        totalLessons: 35,
        category: 'computer',
        icon: 'Icons.code_rounded',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'डेटाबेस',
        description: 'Database',
        totalLessons: 25,
        category: 'computer',
        icon: 'Icons.storage_rounded',
        color: '0xFFFF9800',
      ),
      Subject(
        subjectName: 'कृत्रिम बुद्धिमत्ता',
        description: 'Artificial Intelligence',
        totalLessons: 28,
        category: 'computer',
        icon: 'Icons.smart_toy_rounded',
        color: '0xFFE91E63',
      ),
      Subject(
        subjectName: 'साइबर सुरक्षा',
        description: 'Cyber Security',
        totalLessons: 26,
        category: 'computer',
        icon: 'Icons.security_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'वेब विकास',
        description: 'Web Development',
        totalLessons: 30,
        category: 'computer',
        icon: 'Icons.language_rounded',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'मोबाइल ऐप विकास',
        description: 'Mobile App Development',
        totalLessons: 32,
        category: 'computer',
        icon: 'Icons.phone_android_rounded',
        color: '0xFF4CAF50',
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
                  
                  
                  
                  // Main Subjects
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
                  
                  // Stream Tabs & Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                  const SizedBox(height: 24),
                  // Quick Actions (moved to bottom)
                  _QuickActions(isWide: isWide),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Progress Summary Card
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
    
    final totalProgress = stats['totalProgress'] ?? 0;
    final completedLessons = stats['completedLessons'] ?? 0;
    final progressPercentage = totalProgress > 0
        ? (completedLessons / totalProgress * 100).round()
        : 0;

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
          return Wrap(
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
        }),
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