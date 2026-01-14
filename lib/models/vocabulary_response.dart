class VocabularyResponse {
  final int id;
  final String word;
  final String meaning;
  final String? example;
  final String? phonetic;
  final String? exampleMeaning;
  final String? audioUrl;
  final String? imageUrl;

  VocabularyResponse({
    required this.id,
    required this.word,
    required this.meaning,
    this.example,
    this.phonetic,
    this.exampleMeaning,
    this.audioUrl,
    this.imageUrl,
  });

  factory VocabularyResponse.fromJson(Map<String, dynamic> json) {
    return VocabularyResponse(
      id: (json['id'] as num).toInt(),
      word: json['word'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String?,
      phonetic: json['phonetic'] as String?,
      exampleMeaning: json['exampleMeaning'] as String?,
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
