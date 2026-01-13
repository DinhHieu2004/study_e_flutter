class ProgressStat {
  final String date;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;

  ProgressStat({
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
  });

  factory ProgressStat.fromJson(Map<String, dynamic> json) {
    return ProgressStat(
      date: json['date'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }
}
