import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizController extends ChangeNotifier {
  List questions = [];
  bool loading = false;

  Future<void> fetchQuestions({
    required int amount,
    required String difficulty,
    required String type,
  }) async {
    loading = true;
    notifyListeners();

    final url =
        "https://opentdb.com/api.php?amount=$amount&difficulty=$difficulty&type=$type";

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    questions = data["results"] ?? [];

    loading = false;
    notifyListeners();
  }
}
