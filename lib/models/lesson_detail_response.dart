class LessonDetailResponse {
  final int id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final int topicId;
  final String topicName;

  LessonDetailResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topicId,
    required this.topicName,
    this.imageUrl,
  });

  factory LessonDetailResponse.fromJson(Map<String, dynamic> json) {
    return LessonDetailResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      topicId: (json['topicId'] as num?)?.toInt() ?? 0,
      topicName: json['topicName'] as String? ?? '',
    );
  }
}
