import 'package:flutter/material.dart';

class ExportMyDataPage extends StatefulWidget {
  const ExportMyDataPage({super.key});

  @override
  State<ExportMyDataPage> createState() => _ExportMyDataPageState();
}

class _ExportMyDataPageState extends State<ExportMyDataPage> {
  bool _isExporting = false;
  String? _downloadUrl;

  void _exportData() {
    setState(() {
      _isExporting = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isExporting = false;
        _downloadUrl = 'https://api.nexus-ai.com/exports/user_data_export_2026.json';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Export My Data')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Download Your Personal Nexus AI Archive', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Request a complete export containing your Profile details, Academic records, Planner tasks, Financial summaries, and AI Mentor conversation logs in JSON format.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (_isExporting) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Preparing your archive... Please wait.'),
                  ],
                ),
              ),
            ] else if (_downloadUrl != null) ...[
              Card(
                color: const Color(0xFF10B981).withAlpha(30),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text('Archive Ready for Download!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('URL: $_downloadUrl', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Generate & Export Archive'),
                  onPressed: _exportData,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
