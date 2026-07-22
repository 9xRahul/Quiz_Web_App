import 'package:equatable/equatable.dart';
import '../models/question.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Question> questions;
  final int currentIndex;
  final Map<int, String> userAnswers;   //receives already answerd questions

  const QuizLoaded({
    required this.questions,
    this.currentIndex = 0,
    this.userAnswers = const {},
  });

  QuizLoaded copyWith({
    List<Question>? questions,
    int? currentIndex,
    Map<int, String>? userAnswers,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      userAnswers: userAnswers ?? this.userAnswers,
    );
  }

  @override
  List<Object?> get props => [questions, currentIndex, userAnswers];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
