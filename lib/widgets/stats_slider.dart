import 'package:flutter/material.dart';

class StatsSlider extends StatelessWidget {
  const StatsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _StatCard(
              title: 'कुल छात्र',
              value: '135',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () => _showStudentDetails(context),
            ),
            _StatCard(
              title: 'सक्रिय पाठ',
              value: '63',
              icon: Icons.book,
              color: Colors.green,
              onTap: () => _showActiveLessons(context),
            ),
            _StatCard(
              title: 'औसत प्रगति',
              value: '55%',
              icon: Icons.trending_up,
              color: Colors.orange,
              onTap: () => _showProgressDetails(context),
            ),
            _StatCard(
              title: 'सहायता चाहिए',
              value: '38',
              icon: Icons.error_outline,
              color: Colors.red,
              onTap: () => _showHelpRequests(context),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void _showStudentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('कुल छात्र विवरण'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('कक्षा 10A: 45 छात्र'),
            const Text('कक्षा 10B: 42 छात्र'),
            const Text('कक्षा 11A: 48 छात्र'),
            const SizedBox(height: 8),
            const Text('कुल: 135 छात्र', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
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

  void _showActiveLessons(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('सक्रिय पाठ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('गणित: 15 पाठ'),
            const Text('विज्ञान: 18 पाठ'),
            const Text('अंग्रेजी: 12 पाठ'),
            const Text('हिंदी: 18 पाठ'),
            const SizedBox(height: 8),
            const Text('कुल: 63 सक्रिय पाठ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
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

  void _showProgressDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('औसत प्रगति'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('गणित: 65%'),
            const Text('विज्ञान: 72%'),
            const Text('अंग्रेजी: 58%'),
            const Text('हिंदी: 70%'),
            const SizedBox(height: 8),
            const Text('औसत: 55%', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
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

  void _showHelpRequests(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('सहायता चाहिए'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('राम कुमार - गणित में सहायता'),
            const Text('सीता शर्मा - विज्ञान प्रश्न'),
            const Text('अर्जुन सिंह - अंग्रेजी व्याकरण'),
            const SizedBox(height: 8),
            const Text('कुल: 38 अनुरोध', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 110,
          height: 110,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

