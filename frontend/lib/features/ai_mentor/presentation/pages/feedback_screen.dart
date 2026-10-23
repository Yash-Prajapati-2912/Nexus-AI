import 'package:flutter/material.dart';
import '../../../../di/injection_container.dart';
import '../../domain/entities/mentor_feedback.dart';
import '../../domain/repositories/i_ai_mentor_repository.dart';

class FeedbackScreen extends StatefulWidget {
  final String? messageId;
  const FeedbackScreen({super.key, this.messageId});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 5;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final repository = getIt<IAIMentorRepository>();
      final feedback = MentorFeedback(
        messageId: widget.messageId ?? '',
        rating: _rating,
        feedbackType: 'HELPFUL',
        comment: _feedbackController.text.trim(),
        category: 'GENERAL',
      );

      final result = await repository.submitFeedback(feedback);
      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit feedback: ${failure.message}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback submitted successfully! Thank you.'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit AI Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How satisfied are you with AI Mentor responses?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (idx) {
                final score = idx + 1;
                return IconButton(
                  icon: Icon(
                    score <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: _isSubmitting ? null : () => setState(() => _rating = score),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              enabled: !_isSubmitting,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Share additional comments or recommendations for AI Mentor...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
