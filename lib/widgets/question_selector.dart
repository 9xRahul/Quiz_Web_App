import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';

class QuestionSelector extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, String> userAnswers;

  const QuestionSelector({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentIndex + 1}/$totalQuestions',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Need Help ?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(totalQuestions, (index) {
              final isAnswered = userAnswers.containsKey(index);
              final isCurrent = index == currentIndex;

              Color backgroundColor = const Color(0xFFE5E7EB); // Grey
              Color textColor = Colors.black87;

              if (isAnswered) {
                backgroundColor = const Color(0xFFA4B8F9); // Blue
                textColor = Colors.white;
              } else if (isCurrent) {
                backgroundColor = const Color(0xFFFF9FA8); // Pink
                textColor = Colors.white;
              }

              return InkWell(
                onTap: () {
                  context.read<QuizBloc>().add(NavigateToQuestion(index));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    border: isCurrent && isAnswered 
                        ? Border.all(color: Colors.black, width: 2) 
                        : null,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
