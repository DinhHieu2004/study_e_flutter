import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic_vocabulary.dart';
import '../repositories/topic_vocabulary_repository.dart';

final flashcardTopicProvider =
    StateNotifierProvider<
      FlashcardTopicNotifier,
      AsyncValue<List<TopicVocabulary>>
    >((ref) => FlashcardTopicNotifier());

class FlashcardTopicNotifier
    extends StateNotifier<AsyncValue<List<TopicVocabulary>>> {
  final _repo = TopicVocabularyRepository();

  FlashcardTopicNotifier() : super(const AsyncLoading());

  Future<void> load() async {
    try {
      final data = await _repo.getAllTopics();
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
