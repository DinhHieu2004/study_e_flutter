import '../models/detected_word.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/gemini_repository.dart';


class DetectedWordState {
  final bool loading;
  final DetectedWord? word; 
  final String? error;

  DetectedWordState({this.loading = false, this.word, this.error});

  DetectedWordState copyWith({bool? loading, DetectedWord? word, String? error}) {
    return DetectedWordState(
      loading: loading ?? this.loading,
      word: word ?? this.word,
      error: error,
    );
  }
}


class GeminiNotifier extends StateNotifier<DetectedWordState> {
  GeminiNotifier(this._repo) : super(DetectedWordState());
  final GeminiRepository _repo;

  Future<void> identifyImage(File imageFile) async {
    state = state.copyWith(loading: true, word: null, error: null);
    try {
      final res = await _repo.identifyImage(imageFile);
      if (res != null) {
        state = state.copyWith(loading: false, word: res);
      } else {
        state = state.copyWith(loading: false, error: "Không nhận diện được vật thể");
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: "Lỗi kết nối Server");
    }
  }
}

final geminiRepositoryProvider = Provider<GeminiRepository>((ref) {
  return GeminiRepository();
});

final geminiProvider = StateNotifierProvider<GeminiNotifier, DetectedWordState>((ref) {
  final repo = ref.watch(geminiRepositoryProvider);
  return GeminiNotifier(repo);
});