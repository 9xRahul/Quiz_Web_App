import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/quiz_bloc.dart';
import 'bloc/quiz_event.dart';
import 'repositories/quiz_repository.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => QuizRepository(),
      child: BlocProvider(
        create: (context) => QuizBloc(
          repository: RepositoryProvider.of<QuizRepository>(context),
        )..add(LoadQuiz()),
        child: MaterialApp(
          title: 'Quiz Application',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          ),
          home: const QuizScreen(),
        ),
      ),
    );
  }
}
