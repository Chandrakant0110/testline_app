import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'option_item.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionNumber;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
  });

  @override 
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? selectedOptionIndex;
  bool showExplanation = false;

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
                isSelected: selectedOptionIndex == index,
                onTap: () {
                  setState(() {
                    selectedOptionIndex = index;
                    showExplanation = true;
                  });
                },
              ),
            ),
          ),
          if (showExplanation && widget.question.detailed_solution != null) ...[
            const SizedBox(height: 24),
            Text(
              'Basic Explanation:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.question.detailed_solution!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
