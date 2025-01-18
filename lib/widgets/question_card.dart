import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/question_model.dart';
import 'option_item.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionNumber;
  final Function(double, int) onScoreUpdate;
  final double correctMarks;
  final double negativeMarks;
  final int? selectedAnswer;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.onScoreUpdate,
    required this.correctMarks,
    required this.negativeMarks,
    this.selectedAnswer,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool get showExplanation => widget.selectedAnswer != null;
  bool get showResult => widget.selectedAnswer != null;

  void _handleOptionTap(int index) {
    if (widget.selectedAnswer != null) return; // Prevent multiple selections

    // Calculate score
    final selectedOption = widget.question.options?[index];
    if (selectedOption != null) {
      final score = (selectedOption.is_correct ?? false)
          ? widget.correctMarks
          : -widget.negativeMarks;
      widget.onScoreUpdate(score, index);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (showExplanation && widget.question.detailed_solution != null) ...[
            // const SizedBox(height: 24),
            // Text(
            //   'Basic Explanation:',
            //   style: Theme.of(context).textTheme.titleMedium,
            // ),
            const SizedBox(height: 8),
            MarkdownBody(
              data: widget.question.detailed_solution!,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
