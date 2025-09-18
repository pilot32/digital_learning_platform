import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _StatCard(
          title: "कुल छात्र",
          value: "135",
          icon: Icons.people,
          color: Colors.blue,
          onTap: () => _showDialog(context, "कुल छात्र", const [
            "कक्षा 10A: 45 छात्र",
            "कक्षा 10B: 42 छात्र",
            "कक्षा 11A: 48 छात्र",
            "कुल: 135",
          ]),
        ),
        _StatCard(
          title: "सक्रिय पाठ",
          value: "63",
          icon: Icons.book,
          color: Colors.green,
          onTap: () => _showDialog(context, "सक्रिय पाठ", const [
            "गणित: 15",
            "विज्ञान: 18",
            "अंग्रेजी: 12",
            "हिंदी: 18",
          ]),
        ),
        _StatCard(
          title: "औसत प्रगति",
          value: "55%",
          icon: Icons.trending_up,
          color: Colors.orange,
          onTap: () => _showDialog(context, "औसत प्रगति", const [
            "गणित: 65%",
            "विज्ञान: 72%",
            "अंग्रेजी: 58%",
            "हिंदी: 70%",
          ]),
        ),
        _StatCard(
          title: "सहायता चाहिए",
          value: "38",
          icon: Icons.error_outline,
          color: Colors.red,
          onTap: () => _showDialog(context, "सहायता चाहिए", const [
            "राम - गणित",
            "सीता - विज्ञान",
            "अर्जुन - अंग्रेजी",
          ]),
        ),
      ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

void _showDialog(BuildContext context, String title, List<String> lines) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((e) => Text(e)).toList(),
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