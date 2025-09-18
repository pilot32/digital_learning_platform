import 'package:flutter/material.dart';
import '../models/class_stats.dart';

class ClassPerformance extends StatelessWidget {
  final List<ClassStats> classStats;

  const ClassPerformance({super.key, required this.classStats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "कक्षा का प्रदर्शन",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showFileUploadDialog(context),
              icon: const Icon(Icons.upload, size: 18),
              label: const Text("नया पाठ अपलोड करें"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: classStats.length,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: _ClassCard(stats: classStats[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassStats stats;

  const _ClassCard({required this.stats});

  Color get _color {
    switch (stats.subject) {
      case "हिंदी":
        return Colors.blue;
      case "अंग्रेजी":
        return Colors.green;
      case "गणित":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDialog(context, stats.subject, [
        "छात्र: ${stats.students}",
        "औसत प्रगति: ${stats.progress}%",
        "सहायता चाहिए: ${stats.struggling}",
      ]),
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      stats.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stats.subject,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${stats.students} छात्र",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("औसत प्रगति"),
                        Text(
                          "${stats.progress}%",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: stats.progress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(_color),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${stats.struggling} छात्रों को सहायता चाहिए",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showDialog(context, "विवरण - ${stats.subject}", [
                        "कक्षा वार विवरण",
                        "अध्याय प्रगति",
                        "कठिनाई क्षेत्र",
                      ]),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text(
                        "विवरण देखें",
                        style: TextStyle(fontSize: 12),
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
    );
  }
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