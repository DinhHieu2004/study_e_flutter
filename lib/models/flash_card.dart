class Flashcard {
  final String word;
  final String phonetic;
  final String imageUrl;
  final String audioUrl;
  final String meaning;
  final String example;
  final String exampleMeaning;

  Flashcard({
    required this.word,
    required this.phonetic,
    required this.imageUrl,
    required this.audioUrl,
    required this.meaning,
    required this.example,
    required this.exampleMeaning,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      word: json['word'],
      phonetic: json['phonetic'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      meaning: json['meaning'],
      example: json['example'],
      exampleMeaning: json['exampleMeaning'],
    );
  }
}
