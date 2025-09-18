import 'package:flutter/material.dart';
import '../models/recent_activity.dart';

class RecentActivityList extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "हाल की गतिविधि",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: activities
                  .map((activity) => _ActivityItem(activity: activity))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDialog(context, activity.student, [
        "विषय: ${activity.subject}",
        "क्रिया: ${activity.action}",
        "समय: ${activity.time}",
      ]),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.type == "success" ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              activity.type == "success" ? Icons.check : Icons.warning,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.student,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${activity.subject} - ${activity.action}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                activity.time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
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