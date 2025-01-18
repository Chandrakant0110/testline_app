import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/option_item.dart';
import 'quiz_attempts_review_page.dart';

class QuizReviewPage extends StatelessWidget {
  final Quiz quiz;
  final Map<int, int> userAnswers;
  final double totalScore;

  const QuizReviewPage({
    super.key,
    required this.quiz,
    required this.userAnswers,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = quiz.questions?.length ?? 0;
    final int attemptedQuestions = userAnswers.length;
    final int correctAnswers = _getCorrectAnswersCount();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Quiz Complete!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildScoreCard(
                    context,
                    totalScore: totalScore,
                    totalQuestions: totalQuestions,
                    attemptedQuestions: attemptedQuestions,
                    correctAnswers: correctAnswers,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizAttemptsReviewPage(
                            quiz: quiz,
                            userAnswers: userAnswers,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.teal.shade50,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal.shade200),
                      ),
                    ),
                    icon: const Icon(Icons.rate_review),
                    label: const Text(
                      'Review Attempts',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Finish Review',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context, {
    required double totalScore,
    required int totalQuestions,
    required int attemptedQuestions,
    required int correctAnswers,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Column(
        children: [
          Text(
            totalScore.toStringAsFixed(1),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Score',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.teal.shade700,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                label: 'Total',
                value: totalQuestions.toString(),
              ),
              _buildStatItem(
                context,
                label: 'Attempted',
                value: attemptedQuestions.toString(),
              ),
              _buildStatItem(
                context,
                label: 'Correct',
                value: correctAnswers.toString(),
              ),
              _buildStatItem(
                context,
                label: 'Incorrect',
                value: (attemptedQuestions - correctAnswers).toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.teal.shade700,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.teal.shade700,
              ),
        ),
      ],
    );
  }

  int _getCorrectAnswersCount() {
    int count = 0;
    userAnswers.forEach((questionIndex, userAnswer) {
      final question = quiz.questions?[questionIndex];
      final selectedOption = question?.options?[userAnswer];
      if (selectedOption?.is_correct ?? false) {
        count++;
      }
    });
    return count;
  }
}
