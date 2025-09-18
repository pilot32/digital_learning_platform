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
  
  // Sample data for subjects and lessons
  final List<String> _subjects = ['Mathematics', 'Science', 'History', 'Geography'];
  final Map<String, List<String>> _lessons = {
    'Mathematics': ['Lesson 1', 'Lesson 2', 'Lesson 3'],
    'Science': ['Lesson 1', 'Lesson 2', 'Lesson 3', 'Lesson 4'],
    'History': ['Lesson 1', 'Lesson 2'],
    'Geography': ['Lesson 1', 'Lesson 2', 'Lesson 3', 'Lesson 4', 'Lesson 5'],
  };
  
  final List<String> _videoQualities = [
    'Low (360p)',
    'Medium (480p) recommended',
    'High (720p)',
    'HD (1080p)',
  ];
  
  String? _selectedSubject;
  String? _selectedLesson;
  String _selectedQuality = 'High (720p)';

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
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('लेक्चर डाउनलोड करें'),
              trailing: const Icon(Icons.download),
              onTap: _showDownloadDialog,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _showDownloadDialog() async {
    _selectedSubject = _subjects.first;
    _selectedLesson = _lessons[_selectedSubject]?.first;
    
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Download Lecture'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Select Subject:'),
                    DropdownButton<String>(
                      value: _selectedSubject,
                      isExpanded: true,
                      items: _subjects.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSubject = newValue;
                            _selectedLesson = _lessons[newValue]?.first;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Lesson:'),
                    DropdownButton<String>(
                      value: _selectedLesson,
                      isExpanded: true,
                      items: _lessons[_selectedSubject]?.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLesson = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Quality:'),
                    DropdownButton<String>(
                      value: _selectedQuality,
                      isExpanded: true,
                      items: _videoQualities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedQuality = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Download'),
                  onPressed: () {
                    _startDownload();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  void _startDownload() {
    // Show a snackbar when download starts
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $_selectedLesson of $_selectedSubject in $_selectedQuality...'),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Here you would typically start the actual download process
    // For example:
    // downloadService.downloadLecture(_selectedSubject!, _selectedLesson!);
  }
}
