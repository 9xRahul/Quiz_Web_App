import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../data/offline_questions.dart';

class QuizRepository {
  final String _apiUrl = 'https://quiz-api-9x9d.onrender.com/questions';

  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Question.fromJson(json)).toList();
      } else {
        return _getFallbackQuestions(); // when api is not working loads the offline questions
      }
    } catch (e) {
      return _getFallbackQuestions();// in errro case also do the same step
    }
  }

  List<Question> _getFallbackQuestions() {// here the question is loading from the offline questions
    final List<dynamic> jsonList = jsonDecode(offlineQuestionsJson);
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }
}
