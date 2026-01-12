import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flash_card.dart';
import '../repositories/flashcard_repository.dart';

final flashcardRepositoryProvider = Provider((ref) => FlashcardRepository());

class FlashcardState {
  final List<Flashcard> cards;
  final int index;
  final bool loading;
  final String? error;

  FlashcardState({
    this.cards = const [],
    this.index = 0,
    this.loading = false,
    this.error,
  });

  FlashcardState copyWith({
    List<Flashcard>? cards,
    int? index,
    bool? loading,
    String? error,
  }) {
    return FlashcardState(
      cards: cards ?? this.cards,
      index: index ?? this.index,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class FlashcardNotifier extends StateNotifier<FlashcardState> {
  final FlashcardRepository repository;

  FlashcardNotifier(this.repository) : super(FlashcardState());

  Future<void> load(int lessonId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await repository.getByLesson(lessonId);
      state = state.copyWith(cards: data, loading: false, index: 0);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void next() {
    if (state.cards.isEmpty) return;
    state = state.copyWith(index: (state.index + 1) % state.cards.length);
  }

  void setIndex(int i) {
    state = state.copyWith(index: i);
  }
}

final flashcardProvider =
    StateNotifierProvider<FlashcardNotifier, FlashcardState>(
      (ref) => FlashcardNotifier(ref.read(flashcardRepositoryProvider)),
    );
