import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/pronunciation_repository.dart';

class PartPronunciationState {
  final bool loading;
  final List<String>? parts;
  final String? error;

  PartPronunciationState({
    this.loading = false,
    this.parts,
    this.error,
    });

  PartPronunciationState copyWith({bool? loading, List<String>? parts, String? error}) {
    return PartPronunciationState(
      loading: loading ?? this.loading,
      parts: parts,
      error: error,
    );
  }
}

final pronunciationRepositoryProvider = Provider<PronunciationRepository>((ref) {
  return PronunciationRepository();
});


class PartPronunciationNotifier extends StateNotifier<PartPronunciationState> {
  PartPronunciationNotifier(this._repo) : super(PartPronunciationState());
  final PronunciationRepository _repo;

  Future<void> fetchPartPronunciation(String level) async {
    state = state.copyWith(loading: true, error: null); 
    try {
      final res = await _repo.getPartPronunciation(level);
      state = state.copyWith(loading: false, parts: res);
    } catch (_) {
      state = state.copyWith(loading: false, error: "Lỗi kết nối");
    }
  }
}


final partPronunciationProvider = StateNotifierProvider.family.autoDispose<
    PartPronunciationNotifier, 
    PartPronunciationState, 
    String
>((ref, level) {
  // autoDispose giúp giải phóng bộ nhớ khi không dùng tới nữa
  // Nhưng nếu muốn giữ lại thì bỏ .autoDispose đi
  final repo = ref.read(pronunciationRepositoryProvider);
  return PartPronunciationNotifier(repo);
});