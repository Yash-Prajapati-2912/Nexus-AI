import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/prompt_template.dart';
import '../../domain/entities/student_wellness.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../widgets/ai_mentor_skeleton.dart';
import '../widgets/conversation_card.dart';
import '../widgets/prompt_chip.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/wellness_score_card.dart';

class AIMentorHomePage extends StatefulWidget {
  const AIMentorHomePage({super.key});

  @override
  State<AIMentorHomePage> createState() => _AIMentorHomePageState();
}

class _AIMentorHomePageState extends State<AIMentorHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Mentor', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RouteNames.aiMentorSearch),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.aiMentorHistory),
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RouteNames.aiMentorSettings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AIMentorBloc>().add(const RefreshAIMentorDashboardEvent());
        },
        child: BlocBuilder<AIMentorBloc, AIMentorState>(
          builder: (context, state) {
            if (state is AIMentorLoadingState) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    AIMentorSkeleton(height: 120),
                    SizedBox(height: 16),
                    AIMentorSkeleton(height: 80),
                    SizedBox(height: 16),
                    AIMentorSkeleton(height: 140),
                  ],
                ),
              );
            }

            final wellness = (state is AIMentorLoadedState)
                ? state.wellness
                : const StudentWellness(
                    overallWellnessScore: 86,
                    academicPerformanceScore: 82,
                    financialWellnessScore: 84,
                    productivityScore: 88,
                    careerReadinessScore: 78,
                    goalProgressScore: 85,
                    habitConsistencyScore: 89,
                    wellnessLevel: 'BALANCED',
                    keyRecommendations: ['Maintain study schedule consistency'],
                  );

            final recentConvs = (state is AIMentorLoadedState)
                ? state.recentConversations
                : [
                    Conversation(
                      id: 'c1',
                      title: 'Midterm Prep Coaching',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      messageCount: 8,
                      lastMessageSnippet: 'Focus on Data Structures tree algorithms next.',
                      topic: 'STUDY',
                    ),
                    Conversation(
                      id: 'c2',
                      title: 'Software Engineer Career Path',
                      createdAt: DateTime.now().subtract(const Duration(days: 1)),
                      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
                      messageCount: 5,
                      lastMessageSnippet: 'Highlights System Design fundamentals on resume.',
                      topic: 'CAREER',
                    ),
                  ];

            final prompts = (state is AIMentorLoadedState)
                ? state.suggestedPrompts
                : [
                    const PromptTemplate(id: 'p1', title: 'Exam Strategy', category: 'STUDY', promptText: 'Structure my study plan for upcoming exams.'),
                    const PromptTemplate(id: 'p2', title: 'Save \$100/mo', category: 'FINANCE', promptText: 'How can I save \$100 monthly?'),
                  ];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WellnessScoreCard(wellness: wellness),
                  const SizedBox(height: 20),

                  Text('Mentoring Domains', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      SuggestionCard(
                        title: 'Academic Coaching',
                        description: 'Study schedules, exam prep, & subject analysis.',
                        icon: Icons.menu_book_rounded,
                        color: Colors.blueAccent,
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?topic=STUDY'),
                      ),
                      SuggestionCard(
                        title: 'Career & Placement',
                        description: 'Resume review, skill gap analysis, & roadmap.',
                        icon: Icons.work_rounded,
                        color: Colors.purpleAccent,
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?topic=CAREER'),
                      ),
                      SuggestionCard(
                        title: 'Productivity Coaching',
                        description: 'Time management, habits, & burnout prevention.',
                        icon: Icons.bolt_rounded,
                        color: Colors.orangeAccent,
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?topic=PRODUCTIVITY'),
                      ),
                      SuggestionCard(
                        title: 'Financial Wellness',
                        description: 'Student budgeting, savings tips, & expense advice.',
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?topic=FINANCE'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suggested Prompts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => context.push(RouteNames.aiMentorSuggestedPrompts),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: prompts
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: PromptChip(
                                  prompt: p,
                                  onTap: () => context.push('${RouteNames.aiMentorConversation}?prompt=${Uri.encodeComponent(p.promptText)}'),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Conversations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => context.push(RouteNames.aiMentorHistory),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  ...recentConvs.map((conv) => ConversationCard(
                        conversation: conv,
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${conv.id}'),
                      )),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.aiMentorConversation),
        icon: const Icon(Icons.chat_rounded),
        label: const Text('New Chat'),
      ),
    );
  }
}
