class VocabularyResponse {
  final int id;
  final String word;
  final String meaning; 
  final String example; 
  final String exampleMeaning; 
  final String phonetic;
  final String audioUrl;
  final String imageUrl;

  VocabularyResponse({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
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
    );
  }
}
