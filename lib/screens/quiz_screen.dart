import 'dart:async';
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../widgets/quiz_app_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_bottom_bar.dart';
import '../service/proctor_service.dart';
import 'quiz_review_page.dart';
import 'quiz_start_page.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  int currentQuestionIndex = 0;
  double totalScore = 0;
  Timer? questionTimer;
  int remainingSeconds = 0;
  Question? get currentQuestion => widget.quiz.questions?[currentQuestionIndex];
  final Map<int, int> questionAnswers = {};
  final ProctorService _proctorService = ProctorService();
  bool _isTestTerminated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeProctoring();
    _startTimer();
  }

  Future<void> _initializeProctoring() async {
    try {
      await _proctorService.initialize(
        onTestTerminated: () {
          if (mounted) {
            _handleTestTermination(
                'Test terminated due to violation of proctoring rules');
          }
        },
        onWarning: (message) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize proctoring: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTestTermination(String reason) {
    questionTimer?.cancel();
    setState(() {
      _isTestTerminated = true;
      currentQuestionIndex = 0;
      totalScore = 0;
      questionAnswers.clear();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test Terminated'),
        content: Text(reason),
        actions: [
          TextButton(
            onPressed: () async {
              // First dispose of the current proctor service
              await _proctorService.dispose();
              // Then reset its state
              _proctorService.reset();

              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizStartPage(quiz: widget.quiz),
                  ),
                  (route) => false, // This removes all previous routes
                );
              }
            },
            child: const Text('Return to Start'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    questionTimer?.cancel();
    _proctorService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _proctorService.handleAppLifecycleState(state);
  }

  void _startTimer() {
    questionTimer?.cancel();
    setState(() {
      remainingSeconds = widget.quiz.duration ?? 30;
    });

    questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTestTerminated) {
        timer.cancel();
        return;
      }

      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _handleNext();
      }
    });
  }

  void _handleNext() {
    if (_isTestTerminated) return;

    if (currentQuestionIndex < (widget.quiz.questions?.length ?? 1) - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _startTimer();
    } else {
      _showQuizReview();
    }
  }

  void _handleSkip() {
    if (_isTestTerminated) return;
    _handleNext();
  }

  void _updateScore(double score, int selectedOptionIndex) {
    if (_isTestTerminated) return;

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
    if (_isTestTerminated) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Test Terminated',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                        negativeMarks: double.tryParse(
                                widget.quiz.negative_marks ?? '0') ??
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
      ),
    );
  }
}
