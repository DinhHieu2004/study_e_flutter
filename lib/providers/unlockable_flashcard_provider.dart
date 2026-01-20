import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/unlockable_flashcard.dart';
import '../repositories/flashcard_repository.dart';

final unlockableFlashcardProvider =
    StateNotifierProvider<
      UnlockableFlashcardNotifier,
      AsyncValue<List<UnlockableFlashcard>>
    >((ref) => UnlockableFlashcardNotifier());

class UnlockableFlashcardNotifier
    extends StateNotifier<AsyncValue<List<UnlockableFlashcard>>> {
  UnlockableFlashcardNotifier() : super(const AsyncLoading());

  final FlashcardRepository _repo = FlashcardRepository();

  Future<void> load(int topicId) async {
    try {
      state = const AsyncLoading();
      final data = await _repo.getByTopic(topicId);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void updateUnlocked(int vocabId, UnlockableFlashcard newCard) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.map((c) => c.id == vocabId ? newCard : c).toList(),
    );
  }
}
