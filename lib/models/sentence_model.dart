class SentenceResponse {
  final int id;
  final String content;
  String? phonetic; 
  SentenceResponse({required this.id, required this.content, this.phonetic});

  factory SentenceResponse.fromJson(Map<String, dynamic> json) {
    return SentenceResponse(
      id: json['id'],
      content: json['content'],
    );
  }
}