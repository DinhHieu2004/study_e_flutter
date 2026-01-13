
import 'category_stat.dart';
import 'progress_stat.dart';

class StatsResponse {
  final int totalQuestions;
  final int correctAnswers;
  final double accuracyPercentage;
  final List<CategoryStat> categoryStats;
  final List<ProgressStat> progressStats;

  StatsResponse({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.accuracyPercentage,
    required this.categoryStats,
    required this.progressStats,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      accuracyPercentage: (json['accuracyPercentage'] as num).toDouble(),
      categoryStats: (json['categoryStats'] as List)
          .map((e) => CategoryStat.fromJson(e))
          .toList(),
      progressStats: (json['progressStats'] as List)
          .map((e) => ProgressStat.fromJson(e))
          .toList(),
    );
  }
}
