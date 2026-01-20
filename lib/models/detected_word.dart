class DetectedWord {
  final String en;
  final String ipa;
  final String vn;

  DetectedWord({required this.en, required this.ipa, required this.vn});

  factory DetectedWord.fromJson(Map<String, dynamic> json) {
    return DetectedWord(
      en: json['en'] ?? '',
      ipa: json['ipa'] ?? '',
      vn: json['vn'] ?? '',
    );
  }
}