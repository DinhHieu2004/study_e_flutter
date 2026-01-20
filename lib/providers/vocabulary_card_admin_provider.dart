import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vocabulary_response.dart';
import '../models/topic_vocabulary.dart';
import '../repositories/vocabulary_admin_repository.dart';

class VocabularyAdminState {
  final bool loading;
  final List<VocabularyResponse> vocabularies;
  final List<TopicVocabulary> topics;
  final List<VocabularyResponse> previewList;
  final String? error;

  VocabularyAdminState({
    this.loading = false,
    this.vocabularies = const [],
    this.topics = const [],
    this.previewList = const [],
    this.error,
  });

  VocabularyAdminState copyWith({
    bool? loading,
    List<VocabularyResponse>? vocabularies,
    List<TopicVocabulary>? topics,
    List<VocabularyResponse>? previewList,
    String? error,
  }) {
    return VocabularyAdminState(
      loading: loading ?? this.loading,
      vocabularies: vocabularies ?? this.vocabularies,
      topics: topics ?? this.topics,
      previewList: previewList ?? this.previewList,
      error: error,
    );
  }
}

final vocabularyAdminProvider =
    StateNotifierProvider<VocabularyAdminNotifier, VocabularyAdminState>(
      (ref) => VocabularyAdminNotifier(),
    );

class VocabularyAdminNotifier extends StateNotifier<VocabularyAdminState> {
  final VocabularyAdminRepository _repo = VocabularyAdminRepository();

  VocabularyAdminNotifier() : super(VocabularyAdminState()) {
    loadVocabularies();
    loadTopics();
  }

  Future<void> loadVocabularies() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final vocabularies = await _repo.getVocabularies();

      state = state.copyWith(loading: false, vocabularies: vocabularies);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadTopics() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final topics = await _repo.getAllTopics();

      state = state.copyWith(loading: false, topics: topics);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> previewImport(File file) async {
    try {
      state = state.copyWith(loading: true, previewList: []);

      final result = await _repo.previewImport(file);

      state = state.copyWith(loading: false, previewList: result);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> previewImportBytes(Uint8List bytes, String filename) async {
    try {
      state = state.copyWith(loading: true, previewList: []);

      final result = await _repo.previewImportBytes(bytes, filename);

      state = state.copyWith(loading: false, previewList: result);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> confirmImport() async {
    if (state.previewList.isEmpty) return;

    try {
      state = state.copyWith(loading: true);

      await _repo.confirmImport(state.previewList);
      await loadVocabularies();

      state = state.copyWith(loading: false, previewList: []);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> deleteVocabulary(int id) async {
    state = state.copyWith(
      vocabularies: state.vocabularies.where((e) => e.id != id).toList(),
    );
  }

  void clearPreview() {
    state = state.copyWith(previewList: []);
  }
}
