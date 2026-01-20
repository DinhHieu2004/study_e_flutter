import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/unlock_card_question.dart';
import '../../models/unlockable_flashcard.dart' show UnlockableFlashcard;
import '../../providers/unlock_question_provider.dart';
import '../../repositories/flashcard_repository.dart';
import 'animated_flashcard_unlock.dart';

Future<UnlockableFlashcard?> showCardSplitOverlay(
  BuildContext context, {
  required int cardId,
}) {
  return showGeneralDialog<UnlockableFlashcard?>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'card-split',
    barrierColor: Colors.black.withOpacity(0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) {
      return _CardSplitOverlay(cardId: cardId);
    },
    transitionBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _CardSplitOverlay extends ConsumerStatefulWidget {
  final int cardId;

  const _CardSplitOverlay({required this.cardId});

  @override
  ConsumerState<_CardSplitOverlay> createState() => _CardSplitOverlayState();
}

class _CardSplitOverlayState extends ConsumerState<_CardSplitOverlay> {
  bool _unlocked = false;
  String? _word;
  String? _phonetic;
  String? _imageUrl;
  final FlashcardRepository _repo = FlashcardRepository();

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(unlockQuestionProvider(widget.cardId));

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 24),

                Expanded(
                  flex: 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: AnimatedFlashcardUnlock(
                          unlocked: _unlocked,
                          word: _word,
                          phonetic: _phonetic,
                          imageUrl: _imageUrl,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: questionAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (q) => _buildQuestion(context, q),
                    ),
                  ),
                ),
              ],
            ),

            const Positioned(top: 12, right: 12, child: _CloseButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, UnlockQuestion q) {
    final letters = ['A', 'B', 'C', 'D'];
    debugPrint('questionId = ${q.questionId}');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB7E4C7), width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q.question,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(q.options.length, (i) {
                  final width = (constraints.maxWidth - 12) / 2;

                  return SizedBox(
                    width: width,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        side: const BorderSide(color: Color(0xFF74C69D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _unlocked
                          ? null
                          : () async {
                              final result = await _repo.confirmUnlock(
                                q.questionId,
                                i,
                              );

                              if (result.unlocked) {
                                setState(() {
                                  _unlocked = true;
                                  _word = result.word;
                                  _phonetic = result.phonetic;
                                  _imageUrl = result.imageUrl;
                                });

                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () => Navigator.of(context).pop(
                                    UnlockableFlashcard(
                                      id: widget.cardId,
                                      unlocked: true,
                                      word: result.word,
                                      phonetic: result.phonetic,
                                      imageUrl: result.imageUrl,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop(null);
                              }
                            },
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB7E4C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              letters[i],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q.options[i],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).pop(null),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.close, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}
