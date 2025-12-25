class QuizResultRequest {
  final int score;
  final int total;
  final int duration;
  final DateTime timestamp;
  final List<AnswerDetailRequest> answers;

  QuizResultRequest({
    required this.score,
    required this.total,
    required this.duration,
    required this.timestamp,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
        "score": score,
        "total": total,
        "duration": duration,
        "timestamp": timestamp.toIso8601String(),
        "answers": answers.map((e) => e.toJson()).toList(),
      };
}

class AnswerDetailRequest {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String userAnswer;
  final String category;

  AnswerDetailRequest({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.userAnswer,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        "questionText": questionText,
        "options": options,
        "correctAnswer": correctAnswer,
        "userAnswer": userAnswer,
        "category": category,
      };
}
