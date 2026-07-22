import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _answersKey = 'quiz_user_answers';

  Future<Map<int, String>> loadUserAnswers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedAnswersStr = prefs.getString(_answersKey);
      Map<int, String> savedAnswers = {};

      if (savedAnswersStr != null) {
        final Map<String, dynamic> decoded = jsonDecode(savedAnswersStr);
        decoded.forEach((key, value) {
          savedAnswers[int.parse(key)] = value.toString();
        });
      }   // on app restart shows the already answerd questions
      return savedAnswers;
    } catch (e) {
      return {
        //error case here
      };
    }
  }

  Future<void> saveUserAnswers(Map<int, String> answers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _answersKey,
        jsonEncode(
          answers.map((key, value) => MapEntry(key.toString(), value)),
        ),
      );
    } catch (e) {
      //error case
    }
  }

  Future<void> clearUserAnswers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_answersKey);
    } catch (e) {
      //error case
    }
  }
}
