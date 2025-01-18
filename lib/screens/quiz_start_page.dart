import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import 'quiz_screen.dart';

class QuizStartPage extends StatelessWidget {
  final Quiz quiz;

  const QuizStartPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.title ?? 'Quiz',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                quiz.topic ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              _buildInfoCard(
                context,
                title: 'Duration',
                value: '${quiz.duration ?? 30} seconds per question',
                icon: Icons.timer,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Questions',
                value: '${quiz.questions?.length ?? 0} questions',
                icon: Icons.quiz,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Marks',
                value:
                    '+${quiz.correct_answer_marks} for correct, -${quiz.negative_marks} for incorrect',
                icon: Icons.grade,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(quiz: quiz),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Quiz',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
