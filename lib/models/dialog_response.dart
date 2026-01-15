class DialogResponse {
  final String speaker;
  final String content;
  final String? audioUrl;

  DialogResponse({
    required this.speaker,
    required this.content,
    this.audioUrl,
  });

  factory DialogResponse.fromJson(Map<String, dynamic> json) {
    return DialogResponse(
      speaker: json['speaker'] as String? ?? '',
      content: json['content'] as String? ?? '',
      audioUrl: json['audioUrl'] as String?,
    );
  }
}
