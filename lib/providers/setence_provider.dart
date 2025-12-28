import 'package:flutter_application_1/models/sentence_model.dart';
import 'package:flutter_application_1/providers/pronunciation_provider.dart';
import 'package:flutter_application_1/repositories/pronunciation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SentenceState {
  final bool loading;
  final List<SentenceResponse> sentences;
  final int currentIndex;
  final String? error;

  SentenceState({
    this.loading = false,
    this.sentences = const [],
    this.currentIndex = 0,
    this.error,
  });

  SentenceState copyWith({
    bool? loading,
    List<SentenceResponse>? sentences,
    int? currentIndex,
    String? error,
  }) {
    return SentenceState(
      loading: loading ?? this.loading,
      sentences: sentences ?? this.sentences,
      currentIndex: currentIndex ?? this.currentIndex,
      error: error,
    );
  }
}

class SentenceNotifier extends StateNotifier<SentenceState> {
  SentenceNotifier(this._repo) : super(SentenceState());
  final PronunciationRepository _repo;

  // Trong SentenceNotifier
Future<void> fetchSentences(String level, int part) async {
  state = state.copyWith(loading: true, error: null);
  try {
    final sentences = await _repo.getSentenceByPartAndLevel(level, part);
    
    state = state.copyWith(loading: false, sentences: sentences);

    for (int i = 0; i < sentences.length; i++) {
      try {
        final phonetic = await _repo.getPhonetic(sentences[i].content);
        
        final updatedSentences = List<SentenceResponse>.from(state.sentences);
        updatedSentences[i].phonetic = phonetic;
        
        state = state.copyWith(sentences: updatedSentences);
      } catch (e) {
        print("Lỗi lấy phiên âm cho câu ${i + 1}");
      }
    }
  } catch (e) {
    state = state.copyWith(loading: false, error: "Lỗi kết nối dữ liệu");
  }
}

  void nextSentence() {
    if (state.currentIndex < state.sentences.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }
}

final sentenceProvider =
    StateNotifierProvider.family<SentenceNotifier, SentenceState, String>((
      ref,
      arg,
    ) {
      final repo = ref.read(pronunciationRepositoryProvider);
      return SentenceNotifier(repo);
    });
