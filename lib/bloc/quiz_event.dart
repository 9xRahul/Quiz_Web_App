import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuiz extends QuizEvent {}

class SelectAnswer extends QuizEvent {
  final int questionIndex;
  final String answer;

  const SelectAnswer({required this.questionIndex, required this.answer});

  @override
  List<Object?> get props => [questionIndex, answer];
}

class NavigateToQuestion extends QuizEvent {
  final int index;

  const NavigateToQuestion(this.index);

  @override
  List<Object?> get props => [index];
}

class NextQuestion extends QuizEvent {}

class PreviousQuestion extends QuizEvent {}

class ResetQuiz extends QuizEvent {}
