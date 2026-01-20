import 'package:flutter/material.dart';
import 'animated_flashcard_unlock.dart';

Future<bool?> showCardSplitOverlay(
  BuildContext context, {
  required int cardId,
}) {
  return showGeneralDialog<bool>(
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

class _CardSplitOverlay extends StatefulWidget {
  final int cardId;

  const _CardSplitOverlay({required this.cardId});

  @override
  State<_CardSplitOverlay> createState() => _CardSplitOverlayState();
}

class _CardSplitOverlayState extends State<_CardSplitOverlay> {
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    // TODO: gọi API bằng widget.cardId để lấy câu hỏi
  }

  @override
  Widget build(BuildContext context) {
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
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: AnimatedFlashcardUnlock(unlocked: _unlocked),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Test Panel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Bấm nút để test hiệu ứng unlock',
                          style: TextStyle(fontSize: 15),
                        ),
                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _unlocked
                                ? null
                                : () {
                                    setState(() {
                                      _unlocked = true;
                                    });

                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () => Navigator.of(context).pop(true),
                                    );
                                  },
                            child: const Text('Test Unlock Animation'),
                          ),
                        ),
                      ],
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
        onTap: () => Navigator.of(context).pop(false),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.close, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}
