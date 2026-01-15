import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/flash_card.dart';
import '../../controllers/audio_service.dart';

class FlashcardItem extends StatefulWidget {
  final Flashcard card;
  const FlashcardItem({super.key, required this.card});

  @override
  State<FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<FlashcardItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  bool _front = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _flip() {
    _front ? _controller.forward() : _controller.reverse();
    _front = !_front;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final angle = _anim.value * pi;
          final scale = 1 - (sin(_anim.value * pi) * 0.15);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..scale(scale)
              ..rotateY(angle),
            child: angle < pi / 2
                ? _frontFace()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _backFace(),
                  ),
          );
        },
      ),
    );
  }

  Widget _frontFace() => _card(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          widget.card.imageUrl,
          height: 120,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 80),
        ),
        const SizedBox(height: 12),
        Text(
          widget.card.word,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(widget.card.phonetic, style: const TextStyle(color: Colors.grey)),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            AudioService.play(widget.card.audioUrl);
          },
        ),
      ],
    ),
  );

  Widget _backFace() => _card(
    Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.card.meaning,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.card.example),
          const SizedBox(height: 4),
          Text(
            widget.card.exampleMeaning,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );

  Widget _card(Widget child) => AspectRatio(
    aspectRatio: 3 / 4,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
