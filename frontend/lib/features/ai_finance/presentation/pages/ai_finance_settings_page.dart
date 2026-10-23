import 'package:flutter/material.dart';

class AIFinanceSettingsPage extends StatefulWidget {
  const AIFinanceSettingsPage({super.key});

  @override
  State<AIFinanceSettingsPage> createState() => _AIFinanceSettingsPageState();
}

class _AIFinanceSettingsPageState extends State<AIFinanceSettingsPage> {
  bool _enableAnomalyAlerts = true;
  bool _enableWeeklyAIReviews = true;
  bool _enableOverspendingWarning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Finance Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Unusual Spending Anomaly Alerts'),
            subtitle: const Text('Notify when a transaction exceeds 3x daily average'),
            value: _enableAnomalyAlerts,
            onChanged: (val) => setState(() => _enableAnomalyAlerts = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Weekly AI Financial Review'),
            subtitle: const Text('Generate automated weekly summary Insights'),
            value: _enableWeeklyAIReviews,
            onChanged: (val) => setState(() => _enableWeeklyAIReviews = val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Overspending Probability Warnings'),
            subtitle: const Text('Alert when monthly budget limit is at risk'),
            value: _enableOverspendingWarning,
            onChanged: (val) => setState(() => _enableOverspendingWarning = val),
          ),
        ],
      ),
    );
  }
}
