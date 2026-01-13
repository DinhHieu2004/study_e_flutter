import 'package:file_picker/file_picker.dart';

import '../models/Question_pageable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/quiz_repository.dart';

class QuestionAdminState {
  final bool loading;
  final QuestionResponse? response;
  final String? error;

  QuestionAdminState({this.loading = false, this.response, this.error});

  QuestionAdminState copyWith({
    bool? loading,
    QuestionResponse? response,
    String? error,
  }) {
    return QuestionAdminState(
      loading: loading ?? this.loading,
      response: response ?? this.response,
      error: error,
    );
  }
}

class QuestionAdminNotifier extends StateNotifier<QuestionAdminState> {
  final QuizRepository repository;
  final int page;

  QuestionAdminNotifier(this.repository, this.page)
    : super(QuestionAdminState());

  Future<void> fetchAdminQuestions(int page) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await repository.fetchPaginatedQuestions(
        page: page,
        size: 10,
      );
      state = state.copyWith(loading: false, response: data);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> deleteQuestion(String id) async {
    try {
      await repository.deleteQuestion(id);

      if (state.response != null) {
        final updatedItems = state.response!.items
            .where((q) => q.id != id)
            .toList();

        state = state.copyWith(
          response: QuestionResponse(
            pageNo: state.response!.pageNo,
            pageSize: state.response!.pageSize,
            totalPage: state.response!.totalPage,
            totalItems: state.response!.totalItems - 1,
            items: updatedItems,
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 500));
      await fetchAdminQuestions(page);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> importQuestions(PlatformFile file) async {
    try {
      state = state.copyWith(loading: true, error: null);
      await repository.importQuestion(file);
      await fetchAdminQuestions(page);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository();
});

final questionAdminProvider = StateNotifierProvider.family
    .autoDispose<QuestionAdminNotifier, QuestionAdminState, int>((ref, page) {
      final notifier = QuestionAdminNotifier(
        ref.read(quizRepositoryProvider),
        page,
      );
      notifier.fetchAdminQuestions(page);
      return notifier;
    });
