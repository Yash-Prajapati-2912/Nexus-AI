import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection_container.dart';
import '../../../../router/route_names.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';
import '../widgets/conversation_card.dart';

class AIMentorSearchPage extends StatefulWidget {
  const AIMentorSearchPage({super.key});

  @override
  State<AIMentorSearchPage> createState() => _AIMentorSearchPageState();
}

class _AIMentorSearchPageState extends State<AIMentorSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _isLoading = false;
  String? _errorMessage;
  List<Conversation> _results = [];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = null;
        _results = [];
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      _executeSearch(trimmed);
    });
  }

  Future<void> _executeSearch(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repo = getIt<IAIMentorRepository>();
    final result = await repo.searchConversations(query);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
          _results = [];
        });
      },
      (conversations) {
        setState(() {
          _isLoading = false;
          _results = conversations;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search conversations by title...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      _onQueryChanged('');
                    },
                  )
                : null,
          ),
          onChanged: _onQueryChanged,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, size: 56, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Type to search AI Mentor conversations...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _executeSearch(query),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'No conversations found matching "$query"',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Try searching for another topic or keyword.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final conv = _results[index];
        return ConversationCard(
          conversation: conv,
          onTap: () {
            context.push('${RouteNames.aiMentorConversation}?id=${conv.id}');
          },
        );
      },
    );
  }
}
