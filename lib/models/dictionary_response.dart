class DictionaryResponse {
  final String word;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  DictionaryResponse({
    required this.word,
    required this.phonetics,
    required this.meanings,
  });

  factory DictionaryResponse.fromJson(Map<String, dynamic> json) {
    return DictionaryResponse(
      word: json['word'] as String,
      phonetics:
          (json['phonetics'] as List<dynamic>?)
              ?.map((e) => Phonetic.fromJson(e))
              .toList() ??
          [],
      meanings:
          (json['meanings'] as List<dynamic>?)
              ?.map((e) => Meaning.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'] as String?,
      audio: json['audio'] as String?,
    );
  }
}

class Meaning {
  final String? partOfSpeech;
  final List<Definition> definitions;

  Meaning({this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] as String?,
      definitions:
          (json['definitions'] as List<dynamic>?)
              ?.map((e) => Definition.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Definition {
  final String? definition;
  final String? vietnameseDefinition;
  final String? example;
  final String? vietnameseExample;

  Definition({
    this.definition,
    this.vietnameseDefinition,
    this.example,
    this.vietnameseExample,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] as String?,
      vietnameseDefinition: json['vietnameseDefinition'] as String?,
      example: json['example'] as String?,
      vietnameseExample: json['vietnameseExample'] as String?,
    );
  }
}
