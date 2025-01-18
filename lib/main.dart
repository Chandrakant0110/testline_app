import 'package:flutter/material.dart';
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
      home: const Scaffold(
        body: Center(
          child: Text('data'),
        ),
      ),
    );
  }
}
