
class Question {
  final String id;
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer; 

  Question({
    required this.id,
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: json['correct_answer'] ?? '', 
    );
  }
}

class QuestionResponse {
  final int pageNo;
  final int pageSize;
  final int totalPage;
  final int totalItems;
  final List<Question> items;

  QuestionResponse({
    required this.pageNo,
    required this.pageSize,
    required this.totalPage,
    required this.totalItems,
    required this.items,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      pageNo: json['pageNo'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPage: json['totalPage'] ?? 0,
      totalItems: json['totalItems'] ?? 0,
      items: json['items'] != null 
          ? (json['items'] as List).map((i) => Question.fromJson(i)).toList() 
          : [],
    );
  }
}