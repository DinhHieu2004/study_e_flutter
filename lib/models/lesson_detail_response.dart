class LessonDetailResponse {
  final int id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final int topicId;
  final String topicName;
  final String? audioUrl;
  final String? progressStatus;
  final String? completedAt;

  LessonDetailResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topicId,
    required this.topicName,
    this.imageUrl,
    this.audioUrl,
    this.progressStatus,
    this.completedAt,
  });

  factory LessonDetailResponse.fromJson(Map<String, dynamic> json) {
    return LessonDetailResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      audioUrl: (json['audioUrl'] as String?) ?? (json['audio_url'] as String?),
      topicId: (json['topicId'] as num?)?.toInt() ?? 0,
      topicName: json['topicName'] as String? ?? '',
      progressStatus: json['progressStatus'] as String?,
      completedAt: json['completedAt'] as String?,
    );
  }
}
