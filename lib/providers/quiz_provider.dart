import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_question.dart';
import '../repositories/quiz_repository.dart';
import '../models/quiz_result_request.dart';

// Thêm phương pháp copyWith để cập nhật state dễ dàng hơn
class QuizState {
  final bool loading;
  final List<QuizQuestion> questions;
  final String? error;

  QuizState({
    this.loading = false,
    this.questions = const [],
    this.error,
  });

  // Hàm này cực kỳ quan trọng để Riverpod nhận biết thay đổi
  QuizState copyWith({
    bool? loading,
    List<QuizQuestion>? questions,
    String? error,
  }) {
    return QuizState(
      loading: loading ?? this.loading,
      questions: questions ?? this.questions,
      error: error, // Nếu là null thì reset error
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository repository;

  QuizNotifier(this.repository) : super(QuizState());

  Future<void> fetchQuestions({
    required int amount,
    required String difficulty,
    required String type,
    required int categoryId,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final data = await repository.fetchQuestions(
        amount: amount,
        difficulty: difficulty,
        type: type,
        categoryId: categoryId,
      );
      state = state.copyWith(loading: false, questions: data);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  // SỬA LỖI CHÍNH TẠI ĐÂY: Logic chọn đáp án
  void selectAnswer(int index, String answer) {
    // 1. Tạo bản sao của danh sách
    final List<QuizQuestion> updatedQuestions = List.from(state.questions);
    
    // 2. Cập nhật câu hỏi tại vị trí index bằng cách gán lại (nếu có hàm copyWith trong model thì tốt nhất)
    updatedQuestions[index].userAnswer = answer;

    // 3. Gán lại state bằng một Instance mới hoàn toàn của QuizState
    // Riverpod so sánh "Instance A != Instance B" để quyết định Rebuild UI
    state = state.copyWith(questions: updatedQuestions);
  }

  Future<void> submitQuiz(int duration) async {
    try {
      final score = state.questions
          .where((q) => q.userAnswer == q.correctAnswer)
          .length;

      final answers = state.questions.map((q) {
        return AnswerDetailRequest(
          questionText: q.question,
          options: q.answers,
          correctAnswer: q.correctAnswer,
          userAnswer: q.userAnswer ?? "",
          category: q.category,
        );
      }).toList();

      final request = QuizResultRequest(
        score: score,
        total: state.questions.length,
        duration: duration,
        timestamp: DateTime.now(),
        answers: answers,
      );

      await repository.saveQuizResult(request);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final quizRepositoryProvider = Provider((ref) => QuizRepository());

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.read(quizRepositoryProvider));
});