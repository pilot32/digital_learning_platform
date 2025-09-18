import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fontSize = 'Medium';
  String _language = 'हिंदी';
  bool _downloadLectures = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('सेटिंग्स')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('फ़ॉन्ट आकार'),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Small', label: Text('छोटा')),
                      ButtonSegment(value: 'Medium', label: Text('मध्यम')),
                      ButtonSegment(value: 'Large', label: Text('बड़ा')),
                    ],
                    selected: {_fontSize},
                    onSelectionChanged: (s) => setState(() => _fontSize = s.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('ऐप भाषा'),
              subtitle: Text(_language),
              trailing: DropdownButton<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'हिंदी', child: Text('हिंदी')),
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (v) => setState(() => _language = v ?? _language),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('लेक्चर डाउनलोड करें'),
              value: _downloadLectures,
              onChanged: (v) => setState(() => _downloadLectures = v),
            ),
          ),
        ],
      ),
    );
  }
}


