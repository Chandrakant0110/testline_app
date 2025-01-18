import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../mock/mock_data.dart';
import '../models/models.dart';

class ApiService {
  static const String _baseUrl = 'https://api.jsonserve.com/Uw5CrX';

  Future<Quiz> getQuiz() async {
    try {
      final http.Response response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final quiz = Quiz.fromJson(responseData);
          return quiz;
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing quiz data: $e');
          }
          throw Exception('Failed to parse quiz data: $e');
        }
      } else {
        throw Exception('Failed to load quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load quiz: $e');
    }
  }

  Future<Quiz> fetchLocally() async {
    // await Future.delayed(const Duration(milliseconds: 2300));
    return Quiz.fromJson(mockData);
  }
}
