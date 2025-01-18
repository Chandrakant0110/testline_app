import 'package:flutter/material.dart';

class QuizAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final int currentIndex;
  final double score;

  const QuizAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Score: ${score.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
