import 'package:flutter/material.dart';
import 'student_dashboard_screen_clean.dart';
import 'teacher_dashboard.dart';
import '../models/student.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _studentFormKey = GlobalKey<FormState>();
  final _teacherFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _studentEmailController = TextEditingController();
  final TextEditingController _studentPasswordController = TextEditingController();
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _teacherPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentEmailController.dispose();
    _studentPasswordController.dispose();
    _teacherIdController.dispose();
    _teacherPhoneController.dispose();
    super.dispose();
  }

  void _handleLogin(String userType, Student? student) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$userType लॉग इन सफल! / Login successful!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to StudentDashboardScreen with student data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDashboardScreen(currentStudent: student),
      ),
    );
  }

  Future<void> _handleStudentLogin() async {
    if (_studentFormKey.currentState!.validate()) {
      final email = _studentEmailController.text.trim();
      final password = _studentPasswordController.text.trim();
      
      // Mock authentication - accept any email/password for demo
      if (email.isNotEmpty && password.isNotEmpty) {
        final student = Student(
          name: 'राम कुमार',
          email: email,
          password: password,
          grade: 'Class 10',
          streakDays: 15,
          totalStars: 127,
          badgesEarned: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        );
        _handleLogin('student', student);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('गलत ईमेल या पासवर्ड / Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTeacherLogin() {
    if (_teacherFormKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('शिक्षक लॉगिन सफल! / Teacher login successful!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to TeacherDashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TeacherDashboard(),
        ),
      );
    }
  }

  void _showContactTeacherDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Teacher'),
          content: const Text(
              'For any issues or questions, please contact your teacher directly or email us at: support@nabschool.com'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email address to receive a password reset link:'),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('SEND LINK'),
              onPressed: () {
                // In a real app, you would send a password reset email here
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset link has been sent to your email.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/hero_learning.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.54),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).cardColor.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with mascot
                        Column(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/owl_logo.jpg',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.school,
                                      size: 40,
                                      color: Color(0xFF0F4C75),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'नाभा डिजिटल शिक्षा',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nabha Digital Learning Platform',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Tabs
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            tabs: const [
                              Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.school, size: 16),
                                    SizedBox(width: 8),
                                    Text('छात्र'),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.people, size: 16),
                                    SizedBox(width: 8),
                                    Text('शिक्षक'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tab Content with fixed height
                        SizedBox(
                          height: 320, // Fixed height to prevent overflow
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Student Tab
                              Form(
                                key: _studentFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name Field
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'ईमेल / Email',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _studentEmailController,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        hintText: 'अपना ईमेल दर्ज करें',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                        prefixIcon: const Icon(Icons.email),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया अपना ईमेल दर्ज करें';
                                        }
                                        if (!value.contains('@')) {
                                          return 'वैध ईमेल दर्ज करें';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Password Field
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'पासवर्ड / Password',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _studentPasswordController,
                                      obscureText: true,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        hintText: 'अपना पासवर्ड दर्ज करें',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                        prefixIcon: const Icon(Icons.lock),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया अपना पासवर्ड दर्ज करें';
                                        }
                                        if (value.length < 6) {
                                          return 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _handleStudentLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: const Text(
                                          'लॉग इन करें / Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: _showForgotPasswordDialog,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: _showContactTeacherDialog,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Contact Teacher',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Teacher Tab
                              Form(
                                key: _teacherFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.badge,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 3),
                                        const Text(
                                          'शिक्षक ID / Teacher ID',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    TextFormField(
                                      controller: _teacherIdController,
                                      decoration: InputDecoration(
                                        hintText: 'शिक्षक ID डालें',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                        prefixIcon: const Icon(Icons.badge),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'शिक्षक ID डालें';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'फ़ोन नंबर / Phone Number',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    TextFormField(
                                      controller: _teacherPhoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'अपना फ़ोन नंबर डालें',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                                        prefixIcon: const Icon(Icons.phone),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'फ़ोन नंबर डालें';
                                        }
                                        if (value.length < 10) {
                                          return 'वैध फ़ोन नंबर डालें';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 3),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _handleTeacherLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                        ),
                                        child: const Text(
                                          'लॉग इन करें / Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: _showForgotPasswordDialog,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: _showContactTeacherDialog,
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Contact Support',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Text(
                          'ऑफ़लाइन मोड उपलब्ध • Offline Mode Available',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Made with Love for Nabha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
