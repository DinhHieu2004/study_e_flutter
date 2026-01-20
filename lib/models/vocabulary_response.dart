class VocabularyResponse {
  int id;
  String word;
  String meaning;
  String example;
  int topicId;
  String exampleMeaning;
  String phonetic;
  String audioUrl;
  String imageUrl;

  VocabularyResponse({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
    this.topicId = 0,
    required this.exampleMeaning,
    required this.phonetic,
    required this.audioUrl,
    required this.imageUrl,
  });

  factory VocabularyResponse.fromJson(Map<String, dynamic> json) {
    return VocabularyResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      word: json['word'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String? ?? '',
      exampleMeaning: json['exampleMeaning'] as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      topicId: json['topicId'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      'phonetic': phonetic,
      'example': example,
      'exampleMeaning': exampleMeaning,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'topicId': topicId,
    };
  }
}
