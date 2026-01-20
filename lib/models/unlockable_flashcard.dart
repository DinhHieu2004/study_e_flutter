class UnlockableFlashcard {
  final int id;
  final bool unlocked;

  final String? word;
  final String? phonetic;
  final String? imageUrl;

  final int? remainingAttempts;
  final DateTime? lockedUntil;

  UnlockableFlashcard({
    required this.id,
    required this.unlocked,
    this.word,
    this.phonetic,
    this.imageUrl,
    this.remainingAttempts,
    this.lockedUntil,
  });

  factory UnlockableFlashcard.fromJson(Map<String, dynamic> json) {
    return UnlockableFlashcard(
      id: json['id'] as int,
      unlocked: json['unlocked'] as bool,

      word: json['word'],
      phonetic: json['phonetic'],
      imageUrl: json['imageUrl'],

      remainingAttempts: json['remainingAttempts'],
      lockedUntil: json['lockedUntil'] != null
          ? DateTime.parse(json['lockedUntil'])
          : null,
    );
  }
}
