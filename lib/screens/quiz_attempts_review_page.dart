import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/models.dart';
import '../widgets/option_item.dart';

class QuizAttemptsReviewPage extends StatefulWidget {
  final Quiz quiz;
  final Map<int, int> userAnswers;

  const QuizAttemptsReviewPage({
    super.key,
    required this.quiz,
    required this.userAnswers,
  });

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

  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.quiz.questions?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentPage + 1} of $totalQuestions'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions![index];
                final userAnswer = widget.userAnswers[index];
                return _QuestionReviewCard(
                  question: question,
                  userAnswer: userAnswer,
                  questionNumber: index + 1,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalQuestions,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _QuestionIndicator(
                    questionNumber: index + 1,
                    isSelected: index == _currentPage,
                    isAnswered: widget.userAnswers.containsKey(index),
                    isCorrect: _isAnswerCorrect(index),
                    onTap: () => _navigateToPage(index),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  bool _isAnswerCorrect(int questionIndex) {
    final userAnswer = widget.userAnswers[questionIndex];
    if (userAnswer == null) return false;

    final question = widget.quiz.questions?[questionIndex];
    final selectedOption = question?.options?[userAnswer];
    return selectedOption?.is_correct ?? false;
  }
}

class _QuestionReviewCard extends StatelessWidget {
  final Question question;
  final int? userAnswer;
  final int questionNumber;

  const _QuestionReviewCard({
    required this.question,
    required this.userAnswer,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = userAnswer != null &&
        (question.options?[userAnswer!].is_correct ?? false);

    // Find the correct answer index
    final correctAnswerIndex =
        question.options?.indexWhere((option) => option.is_correct ?? false) ??
            -1;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question $questionNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.teal,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              question.description ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ...List.generate(
              question.options?.length ?? 0,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OptionItem(
                  option: question.options![index],
                  isSelected: userAnswer == index,
                  showResult: true,
                  onTap: () {},
                ),
              ),
            ),
            if (question.detailed_solution != null) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: userAnswer == null
                      ? Colors.grey.shade50
                      : isCorrect
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: userAnswer == null
                        ? Colors.grey.shade200
                        : isCorrect
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          userAnswer == null
                              ? Icons.info_outline
                              : isCorrect
                                  ? Icons.check_circle
                                  : Icons.cancel,
                          color: userAnswer == null
                              ? Colors.grey
                              : isCorrect
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userAnswer == null
                                    ? 'Question Skipped'
                                    : isCorrect
                                        ? 'Correct Answer!'
                                        : 'Incorrect Answer',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: userAnswer == null
                                          ? Colors.grey
                                          : isCorrect
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (userAnswer == null ||
                                  (!isCorrect && correctAnswerIndex >= 0)) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Correct answer: ${question.options?[correctAnswerIndex].description}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: userAnswer == null
                                            ? Colors.grey.shade700
                                            : Colors.red.shade700,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Explanation:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: userAnswer == null
                                ? Colors.grey.shade700
                                : isCorrect
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    MarkdownBody(
                      data: question.detailed_solution!,
                      styleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: userAnswer == null
                                  ? Colors.grey.shade900
                                  : isCorrect
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                            ),
                        h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: userAnswer == null
                                  ? Colors.grey.shade900
                                  : isCorrect
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                            ),
                        h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: userAnswer == null
                                  ? Colors.grey.shade900
                                  : isCorrect
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                            ),
                        listBullet:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: userAnswer == null
                                      ? Colors.grey.shade900
                                      : isCorrect
                                          ? Colors.green.shade900
                                          : Colors.red.shade900,
                                ),
                        blockquote:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: userAnswer == null
                                      ? Colors.grey.shade700
                                      : isCorrect
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                        code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: userAnswer == null
                                  ? Colors.grey.shade900
                                  : isCorrect
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                              backgroundColor: userAnswer == null
                                  ? Colors.grey.shade100
                                  : isCorrect
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                              fontFamily: 'monospace',
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
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
          ),
        ),
      ),
    );
  }
}
