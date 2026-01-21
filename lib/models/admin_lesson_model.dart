class AdminLessonModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final String? imageUrl;
  final String? audioUrl;
  final int topicId;
  final String topicName;
  final String status;
  final bool premium;

  AdminLessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.topicId,
    required this.topicName,
    required this.status,
    required this.premium,
    this.imageUrl,
    this.audioUrl,
  });

  factory AdminLessonModel.fromJson(Map<String, dynamic> json) {
    return AdminLessonModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      topicId: (json['topicId'] as num?)?.toInt() ?? 0,
      topicName: json['topicName'] as String? ?? '',
      status: json['status'] as String? ?? 'normal',
      premium: (json['premium'] == true) || (json['isPremium'] == true),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'title': title,
      'description': description,
      'level': level,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'topicId': topicId,
      'status': status,
      'premium': premium, 
    };
  }

  AdminLessonModel copyWith({
    String? title,
    String? description,
    String? level,
    String? imageUrl,
    String? audioUrl,
    int? topicId,
    String? topicName,
    String? status,
    bool? premium,
  }) {
    return AdminLessonModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      status: status ?? this.status,
      premium: premium ?? this.premium,
    );
  }
}
