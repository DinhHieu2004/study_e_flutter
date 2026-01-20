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
  UnlockableFlashcard copyWith({
    bool? unlocked,
    String? word,
    String? phonetic,
    String? imageUrl,
    int? remainingAttempts,
    DateTime? lockedUntil,
  }) {
    return UnlockableFlashcard(
      id: id,
      unlocked: unlocked ?? this.unlocked,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      imageUrl: imageUrl ?? this.imageUrl,
      remainingAttempts: remainingAttempts ?? this.remainingAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
    );
  }
}
