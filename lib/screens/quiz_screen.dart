import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../widgets/quiz_app_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_bottom_bar.dart';
import 'quiz_review_page.dart';

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
  Timer? questionTimer;
  int remainingSeconds = 0;
  Question? get currentQuestion => widget.quiz.questions?[currentQuestionIndex];
  final Map<int, int> questionAnswers = {}; // Track answers for each question

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
  }

  @override
  void dispose() {
    questionTimer?.cancel();
    super.dispose();
  }

  void _startQuestionTimer() {
    questionTimer?.cancel();
    setState(() {
      remainingSeconds = widget.quiz.duration ?? 30;
    });

    questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _handleNext(); // Auto-move to next question when time's up
      }
    });
  }

  void _handleNext() {
    if (currentQuestionIndex < (widget.quiz.questions?.length ?? 1) - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _startQuestionTimer();
    } else {
      _showQuizReview();
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

  void _showQuizReview() {
    questionTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizReviewPage(
          quiz: widget.quiz,
          userAnswers: questionAnswers,
          totalScore: totalScore,
        ),
      ),
    );
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
            const Divider(height: 1),
            LinearProgressIndicator(
              value: remainingSeconds / (widget.quiz.duration ?? 30),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                remainingSeconds <= 5 ? Colors.red : Colors.teal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '$remainingSeconds seconds remaining',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: remainingSeconds <= 5 ? Colors.red : Colors.grey,
                    ),
              ),
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
