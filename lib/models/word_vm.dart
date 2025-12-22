class WordVm {
  final String id;
  final String word;
  final String meaning;
  final String example;
  final String ipa; 

  const WordVm({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
    this.ipa = "",
  });
}