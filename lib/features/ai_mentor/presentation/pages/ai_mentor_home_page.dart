import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/branding/nexus_logo.dart';
import '../../../../shared/widgets/base_scaffold.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/ai_mentor_bloc.dart';
import '../widgets/ai_mentor_skeleton.dart';

class AIMentorHomePage extends StatefulWidget {
  const AIMentorHomePage({super.key});

  @override
  State<AIMentorHomePage> createState() => _AIMentorHomePageState();
}

class _AIMentorHomePageState extends State<AIMentorHomePage> {
  final TextEditingController _promptInputController = TextEditingController();

  final List<Map<String, dynamic>> _quickActions = const [
    {
      'label': 'Plan my day',
      'icon': Icons.today_rounded,
      'color': Color(0xFF38BDF8),
      'prompt': 'Help me plan my schedule and priorities for today.',
    },
    {
      'label': 'Analyze my spending',
      'icon': Icons.insights_rounded,
      'color': Color(0xFF10B981),
      'prompt': 'Analyze my spending patterns and offer budget advice based on my finance data.',
    },
    {
      'label': 'Help me prioritize tasks',
      'icon': Icons.task_alt_rounded,
      'color': Color(0xFFF59E0B),
      'prompt': 'Review my active academic tasks and help me decide what to tackle first.',
    },
    {
      'label': 'Create a study plan',
      'icon': Icons.school_rounded,
      'color': Color(0xFF8B5CF6),
      'prompt': 'Create a structured study plan for my upcoming courses and exams.',
    },
    {
      'label': 'Review my productivity',
      'icon': Icons.speed_rounded,
      'color': Color(0xFFEC4899),
      'prompt': 'Review my task completion history and suggest productivity habits.',
    },
    {
      'label': 'Help me plan my career',
      'icon': Icons.work_rounded,
      'color': Color(0xFF06B6D4),
      'prompt': 'Provide career path recommendations, skill building guidance, and resume advice.',
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
  }

  @override
  void dispose() {
    _promptInputController.dispose();
    super.dispose();
  }

  void _submitPrompt(String text) {
    final query = text.trim();
    if (query.isEmpty) return;
    _promptInputController.clear();
    context.push('${RouteNames.aiMentorConversation}?prompt=${Uri.encodeComponent(query)}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      appBar: AppBar(
        title: NexusLogo(
          variant: LogoVariant.full,
          markSize: 26,
          fontSize: 18,
          logoTheme: isDark ? LogoTheme.dark : LogoTheme.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(RouteNames.aiMentorSearch),
            tooltip: 'Search Conversations',
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(RouteNames.aiMentorHistory),
            tooltip: 'Conversation History',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RouteNames.aiMentorSettings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocBuilder<AIMentorBloc, AIMentorState>(
        builder: (context, state) {
          if (state is AIMentorLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  AIMentorSkeleton(height: 140),
                  SizedBox(height: 16),
                  AIMentorSkeleton(height: 80),
                  SizedBox(height: 16),
                  AIMentorSkeleton(height: 180),
                ],
              ),
            );
          }

          if (state is AIMentorFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Unable to load AI Mentor Agent',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final recentConvs = (state is AIMentorLoadedState) ? state.recentConversations : <Conversation>[];

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Desktop Left Sidebar: Conversation History & Mentoring Domains
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
                        border: Border(
                          right: BorderSide(
                            color: isDark ? Colors.white10 : Colors.black12,
                          ),
                        ),
                      ),
                      child: _buildDesktopSidebar(context, recentConvs, isDark),
                    ),

                    // Desktop Main Landing Workspace
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: _buildMainLandingContent(context, recentConvs, isDark),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Mobile Layout
              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: _buildMainLandingContent(context, recentConvs, isDark),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainLandingContent(BuildContext context, List<Conversation> recentConvs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 3: Personalized Hero Greeting
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.indigoAccent.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: isDark ? 0.15 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  NexusLogoMark(
                    size: 38,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello! How can I help you today?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your intelligent assistant for productivity, finance, academic planner, & career growth.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Section 4: Context-Aware Intelligence Badges
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildContextBadge('Planner Data Active', Icons.task_alt_rounded, isDark),
                  _buildContextBadge('Finance Metrics Integrated', Icons.account_balance_wallet_rounded, isDark),
                  _buildContextBadge('Academic Context Ready', Icons.school_rounded, isDark),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Section 7: Prominent AI Composer Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.indigoAccent.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptInputController,
                  decoration: const InputDecoration(
                    hintText: 'Ask Nexus AI anything or choose a quick action...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  onSubmitted: _submitPrompt,
                ),
              ),
              IconButton(
                onPressed: () => _submitPrompt(_promptInputController.text),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Section 3: Quick Action Suggestions Grid
        Text(
          'Quick AI Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _quickActions.map((action) {
            final Color actionColor = action['color'] as Color;

            return SizedBox(
              width: 250,
              height: 80,
              child: InkWell(
                onTap: () => _submitPrompt(action['prompt'] as String),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: actionColor.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: actionColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(action['icon'] as IconData, color: actionColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          action['label'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Section 8: Recent Conversations List
        if (recentConvs.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Conversations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              TextButton(
                onPressed: () => context.push(RouteNames.aiMentorHistory),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...recentConvs.take(3).map((conv) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF6366F1),
                    child: Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
                  ),
                  title: Text(conv.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins')),
                  subtitle: Text(conv.lastMessageSnippet, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 18),
                  onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${conv.id}'),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildContextBadge(String label, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.indigoAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.indigoAccent,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // Section 9: Desktop History Sidebar
  Widget _buildDesktopSidebar(BuildContext context, List<Conversation> conversations, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(RouteNames.aiMentorConversation),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'History',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black54,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: conversations.isEmpty
                ? const Center(child: Text('No previous chats', style: TextStyle(fontSize: 12, color: Colors.grey)))
                : ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final c = conversations[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        leading: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.indigoAccent),
                        title: Text(
                          c.title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => context.push('${RouteNames.aiMentorConversation}?id=${c.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
