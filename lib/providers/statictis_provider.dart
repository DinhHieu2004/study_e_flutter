import '../models/stats_response.dart';
import '../repositories/stat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsState {
  final bool isLoading;
  final StatsResponse? data;
  final String? error;

  StatsState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  StatsState copyWith({
    bool? isLoading,
    StatsResponse? data,
    String? error,
  }) {
    return StatsState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}


class StatsNotifier extends StateNotifier<StatsState> {
  StatsNotifier() : super(StatsState());

  final _repo = StatRepository();

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final res = await _repo.getStatistics();
      state = state.copyWith(isLoading: false, data: res);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clear() {
    state = StatsState();
  }
}
 final statsProvider =
    StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  return StatsNotifier();
});
