import 'package:flutter/material.dart';

class AIPlannerSettingsPage extends StatefulWidget {
  const AIPlannerSettingsPage({super.key});

  @override
  State<AIPlannerSettingsPage> createState() => _AIPlannerSettingsPageState();
}

class _AIPlannerSettingsPageState extends State<AIPlannerSettingsPage> {
  String _selectedProvider = 'GEMINI 1.5 PRO';
  bool _autoBalanceWorkload = true;
  bool _deadlineRiskAlerts = true;
  double _defaultSessionDuration = 60;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Planner Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'AI Model Engine',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedProvider,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'GEMINI 1.5 PRO', child: Text('Gemini 1.5 Pro (Recommended)')),
              DropdownMenuItem(value: 'GEMINI 1.5 FLASH', child: Text('Gemini 1.5 Flash (Ultra Fast)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedProvider = val);
            },
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Auto-Balance Workload'),
            subtitle: const Text('Automatically reschedule tasks on overloaded days'),
            value: _autoBalanceWorkload,
            onChanged: (val) => setState(() => _autoBalanceWorkload = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('High-Risk Deadline Alerts'),
            subtitle: const Text('Notify when assignment late probability exceeds 50%'),
            value: _deadlineRiskAlerts,
            onChanged: (val) => setState(() => _deadlineRiskAlerts = val),
          ),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Default Study Session Block',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _defaultSessionDuration,
            min: 15,
            max: 180,
            divisions: 11,
            label: '${_defaultSessionDuration.toInt()} mins',
            onChanged: (val) => setState(() => _defaultSessionDuration = val),
          ),
          Text(
            '${_defaultSessionDuration.toInt()} Minutes per Block',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
