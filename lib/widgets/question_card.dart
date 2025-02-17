import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/question_model.dart';
import '../service/feedback_service.dart';
import 'option_item.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final Function(double, int)? onScoreUpdate; // Made optional for review mode
  final double? correctMarks; // Made optional for review mode
  final double? negativeMarks; // Made optional for review mode
  final int? selectedAnswer;
  final bool isReviewMode; // Added to distinguish between quiz and review modes

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    this.onScoreUpdate,
    this.correctMarks,
    this.negativeMarks,
    this.selectedAnswer,
    this.isReviewMode = false, // Default to quiz mode
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  final FeedbackService _feedbackService = FeedbackService();
  bool get showExplanation =>
      widget.selectedAnswer != null || widget.isReviewMode;
  bool get showResult => widget.selectedAnswer != null || widget.isReviewMode;

  // Find the correct answer index
  int get correctAnswerIndex =>
      widget.question.options?.indexWhere(
        (option) => option.is_correct ?? false,
      ) ??
      -1;

  void _handleOptionTap(int index) async {
    if (widget.selectedAnswer != null || widget.isReviewMode) return;

    final selectedOption = widget.question.options?[index];
    if (selectedOption != null &&
        widget.onScoreUpdate != null &&
        widget.correctMarks != null &&
        widget.negativeMarks != null) {
      final isCorrect = selectedOption.is_correct ?? false;
      final score = isCorrect ? widget.correctMarks! : -widget.negativeMarks!;

      // Play appropriate feedback
      if (isCorrect) {
        _feedbackService.playSuccess();
      } else {
        _feedbackService.playError();
      }

      widget.onScoreUpdate!(score, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.selectedAnswer != null &&
        (widget.question.options?[widget.selectedAnswer!].is_correct ?? false);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${widget.questionNumber}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.teal,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.question.description ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ...List.generate(
            widget.question.options?.length ?? 0,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OptionItem(
                option: widget.question.options![index],
                isSelected: widget.selectedAnswer == index,
                showResult: showResult,
                onTap: () => _handleOptionTap(index),
              ),
            ),
          ),
          if (showResult && widget.question.detailed_solution != null) ...[
            const SizedBox(height: 24),
            _buildExplanationCard(context, isCorrect),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context, bool isCorrect) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.selectedAnswer == null
            ? Colors.grey.shade50
            : isCorrect
                ? Colors.green.shade50
                : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.selectedAnswer == null
              ? Colors.grey.shade200
              : isCorrect
                  ? Colors.green.shade200
                  : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExplanationHeader(context, isCorrect),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _buildExplanationContent(context, isCorrect),
        ],
      ),
    );
  }

  Widget _buildExplanationHeader(BuildContext context, bool isCorrect) {
    return Row(
      children: [
        Icon(
          widget.selectedAnswer == null
              ? Icons.info_outline
              : isCorrect
                  ? Icons.check_circle
                  : Icons.cancel,
          color: widget.selectedAnswer == null
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
                widget.selectedAnswer == null
                    ? 'Question Skipped'
                    : isCorrect
                        ? 'Correct Answer!'
                        : 'Incorrect Answer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.selectedAnswer == null
                          ? Colors.grey
                          : isCorrect
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (widget.selectedAnswer == null ||
                  (!isCorrect && correctAnswerIndex >= 0)) ...[
                const SizedBox(height: 4),
                Text(
                  'Correct answer: ${widget.question.options?[correctAnswerIndex].description}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.selectedAnswer == null
                            ? Colors.grey.shade700
                            : Colors.red.shade700,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationContent(BuildContext context, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explanation:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: widget.selectedAnswer == null
                    ? Colors.grey.shade700
                    : isCorrect
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        MarkdownBody(
          data: widget.question.detailed_solution!,
          styleSheet: MarkdownStyleSheet(
            p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade900
                      : isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                ),
            h1: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade900
                      : isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                ),
            h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade900
                      : isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                ),
            listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade900
                      : isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                ),
            blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade700
                      : isCorrect
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
            code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.selectedAnswer == null
                      ? Colors.grey.shade900
                      : isCorrect
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                  backgroundColor: widget.selectedAnswer == null
                      ? Colors.grey.shade100
                      : isCorrect
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  fontFamily: 'monospace',
                ),
          ),
        ),
      ],
    );
  }
}
