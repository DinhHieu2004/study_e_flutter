import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options;

  QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}

class QuizState {
  final bool loading;
  final List<QuizQuestion> questions;
  final String? error;

  QuizState({
    this.loading = false,
    this.questions = const [],
    this.error,
  });
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  Future<void> fetchQuestions({
    required int amount,
    required String difficulty,
    required String type,
  }) async {
    state = QuizState(loading: true);

    final url =
        "https://opentdb.com/api.php?amount=$amount&difficulty=$difficulty&type=$type";

    try {
      final response = await http.get(Uri.parse(url));

      final data = jsonDecode(response.body);

      List results = data["results"];

      final questions = results.map((e) {
        List<String> options = [
          ...List<String>.from(e["incorrect_answers"]),
          e["correct_answer"]
        ];

        options.shuffle();

        return QuizQuestion(
          question: e["question"],
          correctAnswer: e["correct_answer"],
          options: options,
        );
      }).toList();

      state = QuizState(loading: false, questions: questions);
    } catch (e) {
      state = QuizState(loading: false, error: e.toString());
    }
  }
}

final quizProvider =
    StateNotifierProvider<QuizNotifier, QuizState>((ref) => QuizNotifier());
