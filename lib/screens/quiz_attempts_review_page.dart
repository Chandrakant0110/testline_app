import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/question_card.dart';

class QuizAttemptsReviewPage extends StatefulWidget {
  final Quiz quiz;
  final Map<int, int> userAnswers;
  final int score;

  const QuizAttemptsReviewPage({
    Key? key,
    required this.quiz,
    required this.userAnswers,
    required this.score,
  }) : super(key: key);

  @override
  State<QuizAttemptsReviewPage> createState() => _QuizAttemptsReviewPageState();
}

class _QuizAttemptsReviewPageState extends State<QuizAttemptsReviewPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _navigateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _isAnswerCorrect(int questionIndex) {
    if (!widget.userAnswers.containsKey(questionIndex)) return false;

    final userAnswer = widget.userAnswers[questionIndex];
    final question = widget.quiz.questions?[questionIndex];
    final selectedOption = question?.options?[userAnswer ?? 0];
    return selectedOption?.is_correct ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.quiz.questions?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentPage + 1} of $totalQuestions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions?[index];
                if (question == null) return const SizedBox.shrink();

                return QuestionCard(
                  question: question,
                  questionNumber: index + 1,
                  selectedAnswer: widget.userAnswers[index],
                  isReviewMode: true,
                );
              },
            ),
          ),
          _buildNavigationBar(totalQuestions),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(int totalQuestions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 0
                      ? () => _navigateToPage(_currentPage - 1)
                      : null,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.teal,
                ),
                const SizedBox(width: 24),
                Text(
                  '${_currentPage + 1} / $totalQuestions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: _currentPage < totalQuestions - 1
                      ? () => _navigateToPage(_currentPage + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: totalQuestions,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                separatorBuilder: (context, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => _QuestionIndicator(
                  questionNumber: index + 1,
                  isSelected: index == _currentPage,
                  isAnswered: widget.userAnswers.containsKey(index),
                  isCorrect: _isAnswerCorrect(index),
                  onTap: () => _navigateToPage(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionIndicator extends StatelessWidget {
  final int questionNumber;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback onTap;

  const _QuestionIndicator({
    required this.questionNumber,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? Colors.teal
        : isAnswered
            ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100)
            : Colors.grey.shade100;

    final borderColor = isSelected
        ? Colors.teal
        : isAnswered
            ? (isCorrect ? Colors.green : Colors.red)
            : Colors.grey.shade300;

    final textColor = isSelected
        ? Colors.white
        : isAnswered
            ? (isCorrect ? Colors.green.shade900 : Colors.red.shade900)
            : Colors.grey.shade700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            questionNumber.toString(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
