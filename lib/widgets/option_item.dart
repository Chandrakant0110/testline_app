import 'package:flutter/material.dart';
import '../models/option_model.dart';

class OptionItem extends StatelessWidget {
  final Option option;
  final bool isSelected;
  final bool showResult;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = option.is_correct ?? false;
    final Color backgroundColor;
    final Color borderColor;
    final Color textColor;
    final Widget? trailingIcon;

    if (showResult) {
      if (isSelected) {
        // Selected answer styling
        if (isCorrect) {
          backgroundColor = Colors.green.shade50;
          borderColor = Colors.green;
          textColor = Colors.green.shade900;
          trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
        } else {
          backgroundColor = Colors.red.shade50;
          borderColor = Colors.red;
          textColor = Colors.red.shade900;
          trailingIcon = const Icon(Icons.cancel, color: Colors.red);
        }
      } else if (isCorrect) {
        // Show correct answer if not selected
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green;
        textColor = Colors.green.shade900;
        trailingIcon = const Icon(Icons.check_circle, color: Colors.green);
      } else {
        // Unselected and incorrect answers
        backgroundColor = Colors.grey.shade50;
        borderColor = Colors.grey.shade300;
        textColor = Colors.black54;
        trailingIcon = null;
      }
    } else {
      // Before selection styling
      backgroundColor = isSelected ? Colors.grey.shade100 : Colors.grey.shade50;
      borderColor = isSelected ? Colors.teal : Colors.grey.shade300;
      textColor = isSelected ? Colors.black87 : Colors.black54;
      trailingIcon = null;
    }

    return InkWell(
      onTap: showResult ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.description ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor,
                    ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }
}
