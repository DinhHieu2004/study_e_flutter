import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic_vocabulary.dart';
import '../repositories/topic_vocabulary_repository.dart';

final watchedTopicProvider =
    StateNotifierProvider<
      WatchedTopicNotifier,
      AsyncValue<List<TopicVocabulary>>
    >((ref) => WatchedTopicNotifier());

class WatchedTopicNotifier
    extends StateNotifier<AsyncValue<List<TopicVocabulary>>> {
  final _repo = TopicVocabularyRepository();

  WatchedTopicNotifier() : super(const AsyncLoading());

  Future<void> load() async {
    try {
      final data = await _repo.getWatched();
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
