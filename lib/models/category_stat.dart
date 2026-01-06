class CategoryStat {
  final String categoryName;
  final int totalQuestions;
  final int correctAnswers;
  final double accuracy;

  CategoryStat({
    required this.categoryName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracy,
  });

  factory CategoryStat.fromJson(Map<String, dynamic> json) {
    return CategoryStat(
      categoryName: json['categoryName'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }
}
