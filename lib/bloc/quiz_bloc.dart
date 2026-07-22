import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';
import '../repositories/quiz_repository.dart';
import '../services/shared_prefs_service.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository repository;
  final SharedPrefsService _prefsService = SharedPrefsService();

  QuizBloc({required this.repository}) : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<SelectAnswer>(_onSelectAnswer);
    on<NavigateToQuestion>(_onNavigateToQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<ResetQuiz>(_onResetQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final questions = await repository.fetchQuestions();
      final savedAnswers = await _prefsService.loadUserAnswers(); //load already answersed wuestions from shared preference
      
      emit(QuizLoaded(questions: questions, userAnswers: savedAnswers));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<void> _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      
      if (currentState.userAnswers.containsKey(event.questionIndex)) {
        return;
      }
      
      final Map<int, String> newAnswers = Map.from(currentState.userAnswers);
      newAnswers[event.questionIndex] = event.answer;
      
      await _prefsService.saveUserAnswers(newAnswers); // saves the answer into shared preference
      
      emit(currentState.copyWith(userAnswers: newAnswers)); // emit the updated state
    }
  }

  void _onNavigateToQuestion(NavigateToQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (event.index >= 0 && event.index < currentState.questions.length) {
        emit(currentState.copyWith(currentIndex: event.index));
      }
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentIndex < currentState.questions.length - 1) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex + 1));
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentIndex > 0) {
        emit(currentState.copyWith(currentIndex: currentState.currentIndex - 1));
      }
    }
  }

  Future<void> _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    
    await _prefsService.clearUserAnswers();  // on reset clears the sahred preference
    
    try {
      final questions = await repository.fetchQuestions();
      emit(QuizLoaded(questions: questions, userAnswers: const {}));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
