import 'package:flutter/material.dart';

class FeedbackCard extends StatefulWidget {
  final ValueChanged<int> onRatingSubmitted;

  const FeedbackCard({super.key, required this.onRatingSubmitted});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rate Response:', style: theme.textTheme.bodySmall),
            Row(
              children: List.generate(5, (idx) {
                final starNum = idx + 1;
                return IconButton(
                  icon: Icon(
                    starNum <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _rating = starNum);
                    widget.onRatingSubmitted(starNum);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
