import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/gemini_repository.dart';

class GeminiState {
  final bool loading;
  final String? answer;
  final String? error;

  GeminiState({this.loading = false, this.answer, this.error});

  GeminiState copyWith({bool? loading, String? answer, String? error}) {
    return GeminiState(
      loading: loading ?? this.loading,
      answer: answer,
      error: error,
    );
  }
}

class GeminiNotifier extends StateNotifier<GeminiState> {
  GeminiNotifier(this._repo) : super(GeminiState());
  final GeminiRepository _repo;

  Future<void> fetchGemini(String q, String a) async {
    state = GeminiState(loading: true);
    try {
      final res = await _repo.getGeminiAnswer(q, a);
      state = GeminiState(answer: res);
    } catch (_) {
      state = GeminiState(error: "Lỗi kết nối");
    }
  }
}

final geminiRepositoryProvider = Provider<GeminiRepository>((ref) {
  return GeminiRepository();
});

final geminiProvider =
    StateNotifierProvider.family<GeminiNotifier, GeminiState, String>((ref, questionText) {
  return GeminiNotifier(ref.read(geminiRepositoryProvider));
});