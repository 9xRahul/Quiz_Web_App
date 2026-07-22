import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape.dart';

class Question extends Equatable {
  final String type;
  final String difficulty;
  final String category;
  final String questionText;
  final String description;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> options;

  const Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.questionText,
    required this.description,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    
    final correct = unescape.convert(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List)
        .map((e) => unescape.convert(e as String))
        .toList();
        
    final allOptions = List<String>.from(incorrect)..add(correct);
    allOptions.shuffle();

    return Question(
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      questionText: unescape.convert(json['question'] as String),
      description: unescape.convert(json['description'] ?? 'No explanation available.'),
      correctAnswer: correct,
      incorrectAnswers: incorrect,
      options: allOptions,
    );
  }

  @override
  List<Object?> get props => [
        type,
        difficulty,
        category,
        questionText,
        description,
        correctAnswer,
        incorrectAnswers,
        options,
      ];
}
