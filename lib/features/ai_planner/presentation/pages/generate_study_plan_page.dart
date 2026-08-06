import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';

class GenerateStudyPlanPage extends StatefulWidget {
  const GenerateStudyPlanPage({super.key});

  @override
  State<GenerateStudyPlanPage> createState() => _GenerateStudyPlanPageState();
}

class _GenerateStudyPlanPageState extends State<GenerateStudyPlanPage> {
  String _selectedTimeframe = 'weekly';
  double _dailyGoalMinutes = 120;
  final TextEditingController _subjectController = TextEditingController();
  final List<String> _subjects = ['Computer Science', 'Mathematics', 'Physics'];

  void _addSubject() {
    final text = _subjectController.text.trim();
    if (text.isNotEmpty && !_subjects.contains(text)) {
      setState(() {
        _subjects.add(text);
        _subjectController.clear();
      });
    }
  }

  void _removeSubject(String sub) {
    setState(() {
      _subjects.remove(sub);
    });
  }

  void _onGenerate() {
    context.read<AIPlannerBloc>().add(GeneratePlanEvent(
          timeframe: _selectedTimeframe,
          targetSubjects: _subjects,
          dailyGoalMinutes: _dailyGoalMinutes.toInt(),
        ));
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Study Plan'),
      ),
      body: BlocConsumer<AIPlannerBloc, AIPlannerState>(
        listener: (context, state) {
          if (state is AIPlannerLoadedState && state.currentStudyPlan != null) {
            context.push(RouteNames.aiPlannerPlanDetails, extra: state.currentStudyPlan);
          } else if (state is AIPlannerFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AIPlannerLoadingState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customize AI Study Parameters',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nexus AI will balance your upcoming deadlines, difficulty levels, and study balance.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),

                // Timeframe selector
                Text('Target Timeframe', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'daily', label: Text('Daily')),
                    ButtonSegment(value: 'weekly', label: Text('Weekly')),
                    ButtonSegment(value: 'monthly', label: Text('Monthly')),
                  ],
                  selected: {_selectedTimeframe},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedTimeframe = newSelection.first;
                    });
                  },
                ),

                const SizedBox(height: 24),
                // Daily Study Goal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Daily Study Goal', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('${_dailyGoalMinutes.toInt()} Minutes',
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _dailyGoalMinutes,
                  min: 30,
                  max: 480,
                  divisions: 15,
                  label: '${_dailyGoalMinutes.toInt()} mins',
                  onChanged: (val) {
                    setState(() {
                      _dailyGoalMinutes = val;
                    });
                  },
                ),

                const SizedBox(height: 24),
                // Target Subjects
                Text('Target Subjects', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          hintText: 'Add subject (e.g. Data Structures)',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addSubject(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: _addSubject,
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _subjects.map((sub) {
                    return Chip(
                      label: Text(sub),
                      onDeleted: () => _removeSubject(sub),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _onGenerate,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.auto_awesome_rounded),
                    label: Text(
                      isLoading ? 'AI Analyzing Workload...' : 'Generate AI Study Plan',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
