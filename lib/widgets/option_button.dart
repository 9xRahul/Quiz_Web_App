import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (hasAnswered) {
        if (isCorrect) return Colors.green.withOpacity(0.1);
        if (isSelected && !isCorrect) return Colors.red.withOpacity(0.1);
      }
      return Colors.white;
    }

    Color getBorderColor() {
      if (hasAnswered) {
        if (isCorrect) return Colors.green;
        if (isSelected && !isCorrect) return Colors.red;
      }
      return Colors.transparent;
    }

    Color getTextColor() {
      if (hasAnswered) {
        if (isCorrect) return Colors.green.shade800;
        if (isSelected && !isCorrect) return Colors.red.shade800;
      }
      return Colors.black87;
    }

    return InkWell(
      onTap: hasAnswered ? null : onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 70),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: getBorderColor(), width: 1.5),
          boxShadow: [
            if (!hasAnswered)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            color: getTextColor(),
          ),
        ),
      ),
    );
  }
}
