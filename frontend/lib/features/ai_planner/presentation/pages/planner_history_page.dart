import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ai_history_item.dart';
import '../bloc/ai_planner_bloc.dart';
import '../bloc/ai_planner_event.dart';
import '../bloc/ai_planner_state.dart';
import '../widgets/ai_history_card.dart';
import '../widgets/ai_skeleton_loader.dart';

class PlannerHistoryPage extends StatefulWidget {
  const PlannerHistoryPage({super.key});

  @override
  State<PlannerHistoryPage> createState() => _PlannerHistoryPageState();
}

class _PlannerHistoryPageState extends State<PlannerHistoryPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AIPlannerBloc>().add(const LoadHistoryEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Planner History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search history & requests...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AIPlannerBloc, AIPlannerState>(
              builder: (context, state) {
                if (state is AIPlannerLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: AISkeletonLoader(height: 120),
                  );
                }

                final items = (state is AIPlannerLoadedState && state.historyItems.isNotEmpty)
                    ? state.historyItems
                    : [
                        AIHistoryItem(
                          id: 'h1',
                          prompt: 'Generate 2-week exam preparation plan for Data Structures',
                          responseSummary: 'Created 14-day study plan with 90 min daily slots.',
                          actionType: 'GENERATE_PLAN',
                          createdAt: DateTime.now().subtract(const Duration(days: 1)),
                          isBookmarked: true,
                        ),
                        AIHistoryItem(
                          id: 'h2',
                          prompt: 'Prioritize upcoming 5 deadlines for end of month',
                          responseSummary: 'Identified ML term paper as critical priority.',
                          actionType: 'PRIORITISE',
                          createdAt: DateTime.now().subtract(const Duration(days: 3)),
                          isBookmarked: false,
                        ),
                      ];

                final filtered = items.where((i) {
                  return i.prompt.toLowerCase().contains(_searchQuery) ||
                      i.responseSummary.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No AI history items found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return AIHistoryCard(
                      item: item,
                      onDelete: () {
                        context.read<AIPlannerBloc>().repository.deleteHistoryItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Deleted history item')),
                        );
                      },
                      onBookmarkToggle: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              item.isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
