import 'package:flutter/material.dart';
import 'package:testline_app/screens/quiz_screen.dart';
import 'package:testline_app/service/api_service.dart';
import 'theme/quiz_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: QuizTheme.lightTheme,
      home: FutureBuilder(
        future: ApiService().getQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No quiz data available'));
          }

          return QuizScreen(quiz: snapshot.data!);
        },
      ),
    );
  }
}
