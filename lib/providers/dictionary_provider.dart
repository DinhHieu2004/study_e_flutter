// lib/providers/dictionary_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/dictionary_repository.dart';
import '../models/dictionary_response.dart';

class DictionaryState {
  final bool isLoading;
  final DictionaryResponse? current;
  final String? error;

  DictionaryState({this.isLoading = false, this.current, this.error});

  DictionaryState copyWith({
    bool? isLoading,
    DictionaryResponse? current,
    String? error,
  }) {
    return DictionaryState(
      isLoading: isLoading ?? this.isLoading,
      current: current ?? this.current,
      error: error,
    );
  }
}

class DictionaryNotifier extends StateNotifier<DictionaryState> {
  final DictionaryRepository repo;

  DictionaryNotifier(this.repo) : super(DictionaryState());

  Future<void> searchWord(String word) async {
    if (word.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await repo.getWord(word);
      state = state.copyWith(current: response);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final dictionaryProvider =
    StateNotifierProvider<DictionaryNotifier, DictionaryState>((ref) {
      return DictionaryNotifier(DictionaryRepository());
    });
