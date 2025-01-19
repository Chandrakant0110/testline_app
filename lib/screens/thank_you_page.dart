import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'quiz_start_page.dart';
import '../service/api_service.dart';

class ThankYouPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswerMarks;

  const ThankYouPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswerMarks,
  });

  String _getFeedbackMessage() {
    final totalPossibleScore = totalQuestions * correctAnswerMarks;
    final percentage = (score / totalPossibleScore) * 100;
    if (percentage >= 90) {
      return "Outstanding performance! You're a true champion! 🏆";
    } else if (percentage >= 75) {
      return "Great job! You've done really well! 🌟";
    } else if (percentage >= 60) {
      return "Good effort! Keep practicing! 👍";
    } else {
      return "Don't give up! Every attempt makes you stronger! 💪";
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPossibleScore = totalQuestions * correctAnswerMarks;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final quiz = await ApiService().getQuiz();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => QuizStartPage(quiz: quiz),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Thank You!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                  const SizedBox(height: 20),
                  Lottie.asset(
                    'assets/animations/thank_you.json',
                    height: 200,
                    repeat: true,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _getFeedbackMessage(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3, duration: 600.ms),
                  const SizedBox(height: 20),
                  Text(
                    "Score: $score/$totalPossibleScore",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 800.ms),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      final quiz = await ApiService().getQuiz();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizStartPage(quiz: quiz),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Return to Home",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms)
                      .slideY(begin: 0.5, duration: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
