import 'package:flutter/material.dart';
import 'subject_detail_screen.dart';
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
    _selectedStream = StreamCategory.science; // Initialize the selected stream
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
    // Navigate back to login screen and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false, // This removes all previous routes
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
    
    // Update advanced subjects with categories
    _advancedSubjects = [
      // Science (Vigyan) subjects
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
      Subject(
        subjectName: 'भूगोल',
        description: 'Geography',
        totalLessons: 25,
        category: 'science',
        icon: 'Icons.map_rounded',
        color: '0xFF795548',
      ),
      Subject(
        subjectName: 'खगोल विज्ञान',
        description: 'Astronomy',
        totalLessons: 22,
        category: 'science',
        icon: 'Icons.auto_awesome_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'पर्यावरण विज्ञान',
        description: 'Environmental Science',
        totalLessons: 26,
        category: 'science',
        icon: 'Icons.eco_rounded',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'चिकित्सा विज्ञान',
        description: 'Medical Science',
        totalLessons: 40,
        category: 'science',
        icon: 'Icons.medical_services_rounded',
        color: '0xFFE91E63',
      ),
      
      // Commerce (Komerce) subjects
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
      Subject(
        subjectName: 'साइबर सुरक्षा',
        description: 'Cyber Security',
        totalLessons: 20,
        category: 'computer',
        icon: 'Icons.security_rounded',
        color: '0xFFF44336',
      ),
      Subject(
        subjectName: 'कृत्रिम बुद्धिमत्ता',
        description: 'Artificial Intelligence',
        totalLessons: 28,
        category: 'computer',
        icon: 'Icons.smart_toy_rounded',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'सूचना प्रौद्योगिकी',
        description: 'Information Technology',
        totalLessons: 25,
        category: 'computer',
        icon: 'Icons.developer_board_rounded',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'प्रोग्रामिंग',
        description: 'Programming',
        totalLessons: 35,
        category: 'computer', icon: 'Icons.developer_board_rounded', color: '0xFF4CAF50',
      ),];
    
    final List<Subject> _mainSubjects = [
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
  
    final List<Subject> _advancedSubjects = [
      Subject(
        subjectName: 'भौतिक विज्ञान',
        description: 'Physics',
        totalLessons: 30,
        category: 'science',
        icon: 'Icons.science',
        color: '0xFFE91E63',
      ),
      Subject(
        subjectName: 'रसायन विज्ञान',
        description: 'Chemistry',
        totalLessons: 28,
        category: 'science',
        icon: 'Icons.science',
        color: '0xFF9C27B0',
      ),
      Subject(
        subjectName: 'जीव विज्ञान',
        description: 'Biology',
        totalLessons: 25,
        category: 'science',
        icon: 'Icons.eco',
        color: '0xFF4CAF50',
      ),
      Subject(
        subjectName: 'अर्थशास्त्र',
        description: 'Economics',
        totalLessons: 20,
        category: 'commerce',
        icon: 'Icons.attach_money',
        color: '0xFFFF9800',
      ),
      Subject(
        subjectName: 'व्यवसाय अध्ययन',
        description: 'Business Studies',
        totalLessons: 22,
        category: 'commerce',
        icon: 'Icons.business',
        color: '0xFF2196F3',
      ),
      Subject(
        subjectName: 'लेखाशास्त्र',
        description: 'Accountancy',
        totalLessons: 24,
        category: 'commerce',
        icon: 'Icons.calculate',
        color: '0xFF795548',
      ),
      Subject(
        subjectName: 'इतिहास',
        description: 'History',
        totalLessons: 18,
        category: 'arts',
        icon: 'Icons.history',
        color: '0xFFF44336',
      ),
      Subject(
        subjectName: 'राजनीति विज्ञान',
        description: 'Political Science',
        totalLessons: 20,
        category: 'arts',
        icon: 'Icons.account_balance',
        color: '0xFF3F51B5',
      ),
      Subject(
        subjectName: 'समाजशास्त्र',
        description: 'Sociology',
        totalLessons: 16,
        category: 'arts',
        icon: 'Icons.people',
        color: '0xFFFF5722',
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
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'नमस्ते, ${widget.currentStudent?.name ?? 'छात्र'}!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              'आज भी कुछ नया सीखते हैं',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
            tooltip: 'लॉग आउट',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/student_dashboard_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
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
                  const SizedBox(height: 16),
                  
                  // Quick Actions
                  _QuickActions(isWide: isWide),
                  const SizedBox(height: 24),
                  
                  // Main Subjects
                  _SectionHeader(title: 'मुख्य विषय'),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: _mainSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = _mainSubjects[index];
                      return _buildSubjectCard(
                        context: context,
                        subject: subject,
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
                  
                  const SizedBox(height: 24),
                  
                  // Advanced Education Section
                  _SectionHeader(title: 'उच्च शिक्षा (कक्षा 9-12)'),
                  const SizedBox(height: 16),
                  
                  // Stream Tabs
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          labelColor: Colors.white,
                          unselectedLabelColor: colorScheme.onSurfaceVariant,
                          indicator: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          tabs: StreamCategory.values.map((stream) {
                            return Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(stream.icon, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    stream.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tab Content
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: StreamCategory.values.map((stream) {
                            final subjects = _getFilteredSubjects(stream);
                            return subjects.isEmpty
                                ? _buildEmptyState(theme, 'No subjects available')
                                : GridView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isWide ? 3 : 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemCount: subjects.length,
                                    itemBuilder: (context, index) {
                                      final subject = subjects[index];
                                      return _buildSubjectCard(
                                        context: context,
                                        subject: subject,
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
              Colors.white.withOpacity(0.7), // Reduced opacity for better readability
              BlendMode.dstATop,
            ),
          ),
        ),
        child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _buildProgressSummaryCard(
                isWide: isWide,
                stats: _dashboardStats,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('मुख्य विषय (कक्षा 1-8)', theme),
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
              _buildSectionHeader('उच्च शिक्षा (कक्षा 9-12)', theme),
              const SizedBox(height: 12),
              
              // Stream Selection Tabs with Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tabs with better styling
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      indicator: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      tabs: StreamCategory.values.map((stream) {
                        return Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(stream.icon, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                stream.displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Content for selected tab with fixed height and scrollable content
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: StreamCategory.values.map((stream) {
                        final subjects = _getFilteredSubjects(stream);
                        return subjects.isEmpty
                            ? SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.school_outlined,
                                        size: 32,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'कोई विषय उपलब्ध नहीं है',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'जल्द ही नए विषय जोड़े जाएंगे',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
  final color = subject.color is String 
      ? Color(int.parse(subject.color)) 
      : Color(subject.color);
  
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
              value: 16 / subject.totalLessons, // Calculate progress based on 16 completed lessons
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

// Get icon data for subject category
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

// Progress Summary Card
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

// Section Header
Widget _buildSectionHeader(String title, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    ),
  );
}

// Widget for subject card
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
                    Icons.school,
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
          ],
          ),
      ),
      ),
    );
  }
}

    return _higherSubjects.where((subject) {
      switch (stream) {
        case StreamCategory.science:
          return subject.category == 'science';
        case StreamCategory.commerce:
          return subject.category == 'commerce';
        case StreamCategory.arts:
          return subject.category == 'arts';
      }
    }).toList();
  }

  // Get filtered subjects based on stream
  List<Subject> _getFilteredSubjects(StreamCategory stream) {
    return _advancedSubjects.where((subject) {
      switch (stream) {
        case StreamCategory.science:
          return subject.category == 'science';
        case StreamCategory.commerce:
          return subject.category == 'commerce';
        case StreamCategory.arts:
          return subject.category == 'arts';
      }
    }).toList();
  }

  // Widget for stream cards in horizontal list
  Widget _buildStreamCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required int color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(color).withOpacity(0.1),
          border: Border.all(color: Color(color).withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(color), size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'शुरू करें',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Color(color),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16, color: Color(color)),
              ],
            ),
          ],
        ),
      ),
    );
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
      elevation: 1,
      margin: EdgeInsets.zero,
      color: cs.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBadge(icon: Icons.book, background: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subject.subjectName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subject.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              LinearProgressIndicator(
                value: 0,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
                backgroundColor: cs.surfaceVariant,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '0/${subject.totalLessons} पाठ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '0%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
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
    final cs = theme.colorScheme;

    final totalProgress = stats['totalProgress'] ?? 0;
    final completedLessons = stats['completedLessons'] ?? 0;
    final progressPercentage = totalProgress > 0 
        ? (completedLessons / totalProgress * 100).round() 
        : 0;
    
    final items = [
      ('$progressPercentage%', 'कुल प्रगति', Icons.show_chart_rounded, cs.primary),
      ('${stats['streakDays'] ?? 0}', 'दिन की लकीर', Icons.local_fire_department_rounded, Colors.deepOrange),
      ('${stats['totalStars'] ?? 0}', 'कुल तारे', Icons.star_rounded, Colors.amber),
      ('${stats['badgesEarned'] ?? 0}', 'बैज अर्जित', Icons.verified_rounded, Colors.teal),
    ];

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 12,
              spacing: 12,
              children: items.map((item) {
                return _SummaryTile(
                  value: item.$1,
                  label: item.$2,
                  icon: item.$3,
                  color: item.$4,
                  minWidth: isWide ? 180 : (constraints.maxWidth - 12) / 2,
                );
              }).toList(),
            );
          },
        ),
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
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

