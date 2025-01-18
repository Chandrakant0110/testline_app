import 'package:flutter/material.dart';
import '../models/option_model.dart';

class OptionItem extends StatelessWidget {
  final Option option;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.lightGreen[100] : Colors.grey[100],
          border: Border.all(
            color: isSelected ? Colors.lightGreen : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.description ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected ? Colors.black87 : Colors.black54,
                    ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.lightGreen,
              ),
          ],
        ),
      ),
    );
  }
}
