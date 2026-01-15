class TopicVocabulary {
  final int id;
  final String name;
  final String imagePath;

  TopicVocabulary({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory TopicVocabulary.fromJson(Map<String, dynamic> json) {
    return TopicVocabulary(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }
}
