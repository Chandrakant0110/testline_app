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
  double totalScore = 0;
  Question? get currentQuestion => widget.quiz.questions?[currentQuestionIndex];
  final Map<int, int> questionAnswers = {}; // Track answers for each question

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

  void _updateScore(double score, int selectedOptionIndex) {
    setState(() {
      totalScore += score;
      questionAnswers[currentQuestionIndex] = selectedOptionIndex;
    });
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
              score: totalScore,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Expanded(
              child: currentQuestion != null
                  ? QuestionCard(
                      question: currentQuestion!,
                      questionNumber: currentQuestionIndex + 1,
                      onScoreUpdate: _updateScore,
                      correctMarks: double.tryParse(
                              widget.quiz.correct_answer_marks ?? '1') ??
                          1.0,
                      negativeMarks:
                          double.tryParse(widget.quiz.negative_marks ?? '0') ??
                              0.0,
                      selectedAnswer: questionAnswers[currentQuestionIndex],
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
