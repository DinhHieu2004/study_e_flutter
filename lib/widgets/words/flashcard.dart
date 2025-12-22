import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  final String frontText; 
  final String backText;  

  const Flashcard({
    super.key,
    required this.frontText,
    required this.backText,
  });

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _flipped = !_flipped),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE9ECF2)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 6),
              color: Color(0x11000000),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _flipped ? "Meaning" : "Word",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A8A8A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _flipped ? widget.backText : widget.frontText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap to flip",
              style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
            ),
          ],
        ),
      ),
    );
  }
}
