import 'package:flutter/material.dart';
import '../models/class_stats.dart';
import '../models/recent_activity.dart';
import '../widgets/custom_header.dart';
import '../widgets/stats_slider.dart';
import '../widgets/class_performance.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/quick_actions.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _notificationCount = 3;

  void _handleLogout() {
    // Navigate back to login screen and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: _handleLogout,
            tooltip: 'लॉगआउट / Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              notificationCount: _notificationCount,
              onNotificationPressed: _handleNotification,
              onSettingsPressed: () => _handleSettings(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const StatsSlider(),
                    const SizedBox(height: 32),
                    ClassPerformance(classStats: ClassStats.sampleData),
                    const SizedBox(height: 32),
                    RecentActivityList(activities: RecentActivity.sampleData),
                    const SizedBox(height: 32),
                    QuickActions(
                      onUploadPressed: (context) => _showFileUploadDialog(context),
                      onProgressPressed: (context) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Viewing student progress')),
                        );
                      },
                      onAnalyticsPressed: (context) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Viewing analytics')),
                        );
                      },
                      onSettingsPressed: (context) => _showSettingsDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotification() {
    _showNotificationPanel(context);
  }

  void _handleSettings(BuildContext context) {
    _showSettingsDialog(context);
  }

  void _showNotificationPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'सूचनाएं',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _NotificationItem(
                      title: 'नया छात्र नामांकन',
                      message: 'राम कुमार ने गणित में नामांकन किया',
                      time: '2 मिनट पहले',
                      icon: Icons.person_add_alt_1,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _NotificationItem(
                      title: 'असाइनमेंट जमा',
                      message: 'सीता शर्मा ने हिंदी असाइनमेंट जमा किया',
                      time: '15 मिनट पहले',
                      icon: Icons.assignment_turned_in,
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _NotificationItem(
                      title: 'कक्षा अनुसूची अपडेट',
                      message: 'कक्षा 10A का समय बदला गया',
                      time: '1 घंटा पहले',
                      icon: Icons.schedule,
                      onTap: () {},
                      isRead: true,
                    ),
                    const Divider(height: 1),
                    _NotificationItem(
                      title: 'सिस्टम अपडेट',
                      message: 'नई सुविधाएं उपलब्ध हैं',
                      time: '2 घंटे पहले',
                      icon: Icons.system_update,
                      onTap: () {},
                      isRead: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('बंद करें'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('सेटिंग्स'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SettingsItem(
                icon: Icons.person,
                title: 'प्रोफाइल सेटिंग्स',
                subtitle: 'अपना प्रोफाइल अपडेट करें',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('प्रोफाइल सेटिंग्स खोली गई')),
                  );
                },
              ),
              const Divider(),
              _SettingsItem(
                icon: Icons.notifications,
                title: 'नोटिफिकेशन सेटिंग्स',
                subtitle: 'नोटिफिकेशन प्राथमिकताएं',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('नोटिफिकेशन सेटिंग्स खोली गई')),
                  );
                },
              ),
              const Divider(),
              _SettingsItem(
                icon: Icons.security,
                title: 'सुरक्षा सेटिंग्स',
                subtitle: 'पासवर्ड और सुरक्षा',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('सुरक्षा सेटिंग्स खोली गई')),
                  );
                },
              ),
              const Divider(),
              _SettingsItem(
                icon: Icons.language,
                title: 'भाषा सेटिंग्स',
                subtitle: 'अपनी भाषा चुनें',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('भाषा सेटिंग्स खोली गई')),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('बंद करें'),
          ),
        ],
      ),
    );
  }

  void _showFileUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('नया पाठ अपलोड करें'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'पाठ का शीर्षक',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'विषय चुनें',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'hindi', child: Text('हिंदी')),
                  DropdownMenuItem(value: 'english', child: Text('अंग्रेजी')),
                  DropdownMenuItem(value: 'math', child: Text('गणित')),
                  DropdownMenuItem(value: 'science', child: Text('विज्ञान')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'पाठ का विवरण',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('फाइल अपलोड करने के लिए यहाँ क्लिक करें'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('पाठ सफलतापूर्वक अपलोड किया गया!')),
              );
            },
            child: const Text('अपलोड करें'),
          ),
        ],
      ),
    );
  }

  void _showPieChartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('छात्र प्रगति - पाई चार्ट'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const SweepGradient(
                    colors: [
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                      Colors.red,
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: const Center(
                  child: Text(
                    '78%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'कक्षा प्रगति विवरण',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ChartLegendItem(
                color: Colors.green,
                label: 'उत्कृष्ट (30%)',
                value: '45 छात्र',
              ),
              _ChartLegendItem(
                color: Colors.blue,
                label: 'अच्छा (48%)',
                value: '72 छात्र',
              ),
              _ChartLegendItem(
                color: Colors.orange,
                label: 'सामान्य (15%)',
                value: '23 छात्र',
              ),
              _ChartLegendItem(
                color: Colors.red,
                label: 'कमजोर (7%)',
                value: '10 छात्र',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('बंद करें'),
          ),
        ],
      ),
    );
  }

  void _showBarChartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('विश्लेषण - बार ग्राफ'),
        content: SizedBox(
          width: 450,
          height: 400,
          child: Column(
            children: [
              const Text(
                'विषय-वार प्रदर्शन',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _BarChartItem(
                      height: 80,
                      color: Colors.blue,
                      label: 'हिंदी',
                      value: '85%',
                    ),
                    _BarChartItem(
                      height: 60,
                      color: Colors.green,
                      label: 'अंग्रेजी',
                      value: '72%',
                    ),
                    _BarChartItem(
                      height: 45,
                      color: Colors.orange,
                      label: 'गणित',
                      value: '55%',
                    ),
                    _BarChartItem(
                      height: 70,
                      color: Colors.purple,
                      label: 'विज्ञान',
                      value: '78%',
                    ),
                    _BarChartItem(
                      height: 35,
                      color: Colors.red,
                      label: 'सामाजिक',
                      value: '42%',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Text(
                      'सारांश',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('कुल छात्र: 150'),
                    Text('औसत प्रगति: 66%'),
                    Text('सर्वोत्तम विषय: हिंदी'),
                    Text('सुधार की आवश्यकता: सामाजिक'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('बंद करें'),
          ),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _ChartLegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartItem extends StatelessWidget {
  final double height;
  final Color color;
  final String label;
  final String value;

  const _BarChartItem({
    required this.height,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Settings Item Widget
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// Notification Item Widget
class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isRead;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.icon,
    this.onTap,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[50] : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRead ? Colors.grey[200]! : Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: icon != null ? Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ) : null,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead ? Colors.grey[700] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isRead ? Colors.grey[600] : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: isRead ? Colors.grey[500] : Colors.blue[700],
              ),
            ),
          ],
        ),
        onTap: onTap ?? () {},
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}