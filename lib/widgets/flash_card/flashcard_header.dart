import 'package:flutter/material.dart';

class FlashcardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const FlashcardHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.blue,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
