import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/study_plan.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../widgets/ai_summary_widget.dart';
import '../widgets/study_timeline_widget.dart';

class StudyPlanDetailsPage extends StatefulWidget {
  final StudyPlan? plan;

  const StudyPlanDetailsPage({super.key, this.plan});

  @override
  State<StudyPlanDetailsPage> createState() => _StudyPlanDetailsPageState();
}

class _StudyPlanDetailsPageState extends State<StudyPlanDetailsPage> {
  late StudyPlan _currentPlan;

  @override
  void initState() {
    super.initState();
    _currentPlan = widget.plan ??
        StudyPlan(
          id: 'demo-plan-id',
          title: 'AI Optimized Weekly Study Blueprint',
          summary:
              'Balanced allocation focusing 60% time on high-pressure Computer Science assignments, with scheduled 15-minute Pomodoro breaks.',
          timeframe: 'weekly',
          reasoning: const [
            'CS assignment carries 30% of total grade.',
            'Best focus hours detected between 08:00 AM - 11:00 AM.',
            'Avoided overloading Wednesday due to 3 back-to-back lectures.',
          ],
          actionItems: [
            ActionItem(
              step: 1,
              title: 'Draft System Architecture & ERD',
              allocatedMinutes: 90,
              targetDate: DateTime.now().add(const Duration(days: 1)),
              category: 'CS Assignment',
            ),
            ActionItem(
              step: 2,
              title: 'Solve Linear Algebra Practice Problem Set #4',
              allocatedMinutes: 60,
              targetDate: DateTime.now().add(const Duration(days: 2)),
              category: 'Mathematics',
            ),
            ActionItem(
              step: 3,
              title: 'Review Thermodynamics Chapter 5 Notes',
              allocatedMinutes: 45,
              targetDate: DateTime.now().add(const Duration(days: 3)),
              category: 'Physics',
            ),
          ],
          warnings: const ['High workload detected on Thursday.'],
          confidenceScore: 0.94,
          providerName: 'GEMINI 1.5 PRO',
          createdAt: DateTime.now(),
        );
  }

  void _onSavePlan() {
    context.read<AIPlannerBloc>().add(SavePlanEvent(_currentPlan));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Study Plan saved to Bookmarks!')),
    );
  }

  void _onRegenerate() {
    context.read<AIPlannerBloc>().add(GeneratePlanEvent(
          timeframe: _currentPlan.timeframe,
        ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Regenerating AI Study Plan...')),
    );
  }

  void _onExport(String format) {
    context.read<AIPlannerBloc>().add(ExportPlanEvent(plan: _currentPlan, format: format));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported plan as ${format.toUpperCase()}')),
    );
  }

  void _onCompare() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compare AI Plans'),
        content: const Text(
          'Comparing active plan against past saved blueprint:\n\n'
          '• Current Plan: Higher focus on CS (90m/day)\n'
          '• Past Plan: Balanced across all 3 subjects (45m/day)\n\n'
          'AI Recommendation: Stick with Current Plan for upcoming assignment submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Plan Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: _onSavePlan,
            tooltip: 'Save Plan',
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'export_pdf') _onExport('pdf');
              if (val == 'export_md') _onExport('markdown');
              if (val == 'compare') _onCompare();
              if (val == 'regenerate') _onRegenerate();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'regenerate', child: Text('Regenerate Plan')),
              const PopupMenuItem(value: 'compare', child: Text('Compare Plans')),
              const PopupMenuItem(value: 'export_pdf', child: Text('Export as PDF')),
              const PopupMenuItem(value: 'export_md', child: Text('Export as Markdown')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AISummaryWidget(
              title: _currentPlan.title,
              summary: _currentPlan.summary,
              reasoning: _currentPlan.reasoning,
              confidenceScore: _currentPlan.confidenceScore,
              providerName: _currentPlan.providerName,
            ),
            const SizedBox(height: 24),
            Text(
              'Recommended Action Plan',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StudyTimelineWidget(actionItems: _currentPlan.actionItems),
          ],
        ),
      ),
    );
  }
}
