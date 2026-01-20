class UnlockQuestion {
  final int questionId;
  final String question;
  final List<String> options;

  UnlockQuestion({
    required this.questionId,
    required this.question,
    required this.options,
  });

  factory UnlockQuestion.fromJson(Map<String, dynamic> json) {
    return UnlockQuestion(
      questionId: json['questionId'],
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }
}
