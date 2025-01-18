import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../widgets/quiz_app_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_bottom_bar.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  Question? get currentQuestion => widget.quiz.questions?[currentQuestionIndex];

  void _handleNext() {
    if (currentQuestionIndex < (widget.quiz.questions?.length ?? 1) - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _handleSkip() {
    _handleNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            QuizAppBar(
              title: widget.quiz.title ?? 'Maths Quiz',
              subtitle: '${widget.quiz.questions?.length ?? 0} Questions',
              currentIndex: currentQuestionIndex,
            ),
            Expanded(
              child: currentQuestion != null
                  ? QuestionCard(
                      question: currentQuestion!,
                      questionNumber: currentQuestionIndex + 1,
                    )
                  : const Center(child: Text('No questions available')),
            ),
            QuizBottomBar(
              onSkip: _handleSkip,
              onNext: _handleNext,
            ),
          ],
        ),
      ),
    );
  }
}
