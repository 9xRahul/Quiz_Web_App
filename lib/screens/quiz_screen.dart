import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/question_card.dart';
import '../widgets/option_button.dart';
import '../widgets/explanation_card.dart';
import '../widgets/question_selector.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Title', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            tooltip: 'Reset Game',
            onPressed: () {
              context.read<QuizBloc>().add(ResetQuiz());
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listenWhen: (previous, current) {
          if (current is QuizLoaded) {
            if (previous is QuizLoaded) {
              return previous.userAnswers.length != current.questions.length && 
                     current.userAnswers.length == current.questions.length;
            } else if (previous is QuizLoading || previous is QuizInitial) {
              return current.userAnswers.length == current.questions.length;
            }
          }
          return false;
        },
        listener: (context, state) {
          if (state is QuizLoaded) {
            _showCongratsDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is QuizInitial || state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is QuizLoaded) {
            return _buildQuizLayout(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildQuizLayout(BuildContext context, QuizLoaded state) {
    final question = state.questions[state.currentIndex];
    final hasAnswered = state.userAnswers.containsKey(state.currentIndex);
    final selectedAnswer = state.userAnswers[state.currentIndex];

    Widget buildLeftColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuestionCard(
            questionIndex: state.currentIndex,
            questionText: question.questionText,
          ),
          const SizedBox(height: 24),
          ...question.options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: OptionButton(
                option: option,
                isSelected: selectedAnswer == option,
                isCorrect: option == question.correctAnswer,
                hasAnswered: hasAnswered,
                onTap: () {
                  context.read<QuizBloc>().add(
                        SelectAnswer(
                          questionIndex: state.currentIndex,
                          answer: option,
                        ),
                      );
                },
              ),
            );
          }),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: state.currentIndex > 0
                    ? () => context.read<QuizBloc>().add(PreviousQuestion())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                ),
                child: const Text('Prev', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: state.currentIndex < state.questions.length - 1
                    ? () => context.read<QuizBloc>().add(NextQuestion())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                ),
                child: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: hasAnswered,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: ExplanationCard(explanation: question.description),
          ),
        ],
      );
    }

    Widget buildRightColumn() {
      return QuestionSelector(
        totalQuestions: state.questions.length,
        currentIndex: state.currentIndex,
        userAnswers: state.userAnswers,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        if (isDesktop) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: SingleChildScrollView(
                        child: buildLeftColumn(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: buildRightColumn(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLeftColumn(),
                  const SizedBox(height: 32),
                  buildRightColumn(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showCongratsDialog(BuildContext context, QuizLoaded state) {
    int correctAnswers = 0;
    for (var entry in state.userAnswers.entries) {
      if (state.questions[entry.key].correctAnswer == entry.value) {
        correctAnswers++;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Congratulations! 🎉'),
          content: Text('You have completed the quiz.\nYour score is $correctAnswers / ${state.questions.length}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Review Answers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<QuizBloc>().add(ResetQuiz());
              },
              child: const Text('Reset Game'),
            ),
          ],
        );
      },
    );
  }
}
