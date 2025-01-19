import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    quiz.title ?? 'Quiz',
                    textStyle:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
              ),
              const SizedBox(height: 8),
              Text(
                quiz.topic ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 32),
              _buildInfoCard(
                context,
                title: 'Duration',
                value: '${quiz.duration ?? 30} seconds per question',
                icon: Icons.timer,
                delay: 0,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Questions',
                value: '${quiz.questions?.length ?? 0} questions',
                icon: Icons.quiz,
                delay: 200,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                context,
                title: 'Marks',
                value:
                    '+${quiz.correct_answer_marks} for correct, -${quiz.negative_marks} for incorrect',
                icon: Icons.grade,
                delay: 400,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            QuizScreen(quiz: quiz),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 500),
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
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms)
                  .slideY(begin: 0.2, end: 0),
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
    required int delay,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 500.ms)
        .slideX(begin: 0.2, end: 0);
  }
}
