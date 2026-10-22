import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection_container.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';
import '../bloc/ai_mentor_bloc.dart';

class ConversationDetailsPage extends StatefulWidget {
  final String? conversationId;
  final Conversation? initialConversation;

  const ConversationDetailsPage({
    super.key,
    this.conversationId,
    this.initialConversation,
  });

  @override
  State<ConversationDetailsPage> createState() => _ConversationDetailsPageState();
}

class _ConversationDetailsPageState extends State<ConversationDetailsPage> {
  Conversation? _conversation;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialConversation != null) {
      _conversation = widget.initialConversation;
    } else if (widget.conversationId != null && widget.conversationId!.isNotEmpty) {
      _loadConversation(widget.conversationId!);
    }
  }

  Future<void> _loadConversation(String id) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = getIt<IAIMentorRepository>();
      final result = await repository.getConversationById(id);
      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() {
            _isLoading = false;
            _errorMessage = failure.message;
          });
        },
        (conv) {
          setState(() {
            _isLoading = false;
            _conversation = conv;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> _renameConversation() async {
    if (_conversation == null) return;
    final controller = TextEditingController(text: _conversation!.title);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Conversation Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty && newTitle != _conversation!.title && mounted) {
      try {
        final repo = getIt<IAIMentorRepository>();
        final res = await repo.updateConversation(_conversation!.id, title: newTitle);
        if (!mounted) return;

        res.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to rename: ${failure.message}'), backgroundColor: Colors.redAccent),
          ),
          (updated) {
            setState(() => _conversation = updated);
            context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conversation renamed successfully.'), backgroundColor: Color(0xFF10B981)),
            );
          },
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _togglePin() async {
    if (_conversation == null) return;
    final targetPin = !_conversation!.isPinned;

    try {
      final repo = getIt<IAIMentorRepository>();
      final res = await repo.updateConversation(_conversation!.id, isPinned: targetPin);
      if (!mounted) return;

      res.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update pin state: ${failure.message}'), backgroundColor: Colors.redAccent),
        ),
        (updated) {
          setState(() => _conversation = updated);
          context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(targetPin ? 'Conversation pinned to top.' : 'Conversation unpinned.'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _toggleArchive() async {
    if (_conversation == null) return;
    final targetArchive = !_conversation!.isArchived;

    try {
      final repo = getIt<IAIMentorRepository>();
      final res = await repo.updateConversation(_conversation!.id, isArchived: targetArchive);
      if (!mounted) return;

      res.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update archive state: ${failure.message}'), backgroundColor: Colors.redAccent),
        ),
        (updated) {
          setState(() => _conversation = updated);
          context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(targetArchive ? 'Conversation archived.' : 'Conversation unarchived.'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _deleteConversation() async {
    if (_conversation == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Conversation?'),
        content: Text('Are you sure you want to delete "${_conversation!.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final repo = getIt<IAIMentorRepository>();
        final res = await repo.deleteConversation(_conversation!.id);
        if (!mounted) return;

        res.fold(
          (failure) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: ${failure.message}'), backgroundColor: Colors.redAccent),
          ),
          (_) {
            context.read<AIMentorBloc>().add(const LoadAIMentorDashboardEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conversation deleted.'), backgroundColor: Color(0xFF10B981)),
            );
            Navigator.pop(context, true);
          },
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversation Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null && _conversation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Conversation Details')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text('Error loading conversation: $_errorMessage', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                if (widget.conversationId != null)
                  ElevatedButton(
                    onPressed: () => _loadConversation(widget.conversationId!),
                    child: const Text('Retry'),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final conv = _conversation;
    final messageCount = conv != null
        ? (conv.messages.isNotEmpty ? conv.messages.length : conv.messageCount)
        : 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Conversation Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversation Info',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Title: ${conv?.title ?? "Untitled"}'),
                  const SizedBox(height: 4),
                  Text('Topic: ${conv != null && conv.topic.isNotEmpty ? conv.topic : "General"}'),
                  const SizedBox(height: 4),
                  Text('Created: ${_formatDate(conv?.createdAt)}'),
                  const SizedBox(height: 4),
                  Text('Messages: $messageCount'),
                  const SizedBox(height: 4),
                  Text('Status: ${conv?.isPinned == true ? "Pinned" : (conv?.isArchived == true ? "Archived" : "Active")}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Rename Conversation'),
            onTap: _renameConversation,
          ),
          ListTile(
            leading: Icon(
              conv?.isPinned == true ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: conv?.isPinned == true ? Colors.amber : null,
            ),
            title: Text(conv?.isPinned == true ? 'Unpin from Top' : 'Pin to Top'),
            onTap: _togglePin,
          ),
          ListTile(
            leading: Icon(
              conv?.isArchived == true ? Icons.unarchive_rounded : Icons.archive_rounded,
            ),
            title: Text(conv?.isArchived == true ? 'Unarchive Conversation' : 'Archive Conversation'),
            onTap: _toggleArchive,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
            title: const Text('Delete Conversation', style: TextStyle(color: Colors.redAccent)),
            onTap: _deleteConversation,
          ),
        ],
      ),
    );
  }
}
