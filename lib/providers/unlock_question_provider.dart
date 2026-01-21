import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/flashcard_repository.dart';
import '../../models/unlock_card_question.dart';

final unlockQuestionProvider = FutureProvider.autoDispose
    .family<UnlockQuestion, int>((ref, cardId) async {
      final repo = FlashcardRepository();
      return repo.getUnlockQuestion(cardId);
    });
