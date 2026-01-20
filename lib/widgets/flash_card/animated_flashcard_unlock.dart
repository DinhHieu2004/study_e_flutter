import 'package:flutter/material.dart';
import 'lock_flashcard_tile.dart';
import 'unlocked_flashcard_tile.dart';

class AnimatedFlashcardUnlock extends StatefulWidget {
  final bool unlocked;
  final String? word;
  final String? phonetic;
  final String? imageUrl;

  const AnimatedFlashcardUnlock({
    super.key,
    required this.unlocked,
    this.word,
    this.phonetic,
    this.imageUrl,
  });

  @override
  State<AnimatedFlashcardUnlock> createState() =>
      _AnimatedFlashcardUnlockState();
}

class _AnimatedFlashcardUnlockState extends State<AnimatedFlashcardUnlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_controller);

    _glowOpacity = Tween(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedFlashcardUnlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// ▶️ chạy animation khi:
    /// 1. vừa unlock
    /// 2. hoặc word vừa được set
    final justUnlocked = !oldWidget.unlocked && widget.unlocked;
    final wordJustArrived = oldWidget.word == null && widget.word != null;

    if (justUnlocked || wordJustArrived) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            /// ✨ Glow
            if (widget.unlocked)
              Opacity(
                opacity: _glowOpacity.value,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

            /// 📦 Card
            Transform.scale(
              scale: widget.unlocked ? _scale.value : 1.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: widget.unlocked
                    ? UnlockedFlashcardTile(
                        key: ValueKey('unlocked_${widget.word ?? 'empty'}'),
                        word: widget.word ?? '',
                        phonetic: widget.phonetic,
                        imageUrl: widget.imageUrl,
                        large: true,
                      )
                    : const LockedFlashcardTile(
                        key: ValueKey('locked'),
                        large: true,
                      ),
              ),
            ),

            /// 🔓 Icon
            if (widget.unlocked)
              Positioned(
                top: 12,
                right: 12,
                child: FadeTransition(
                  opacity: _glowOpacity,
                  child: const Icon(
                    Icons.lock_open_rounded,
                    size: 32,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
