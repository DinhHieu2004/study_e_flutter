import 'package:flutter/material.dart';
import '../../models/word_vm.dart';

class WordRow extends StatelessWidget {
  final WordVm word;
  final VoidCallback? onStar;
  final bool starred;

  const WordRow({
    super.key,
    required this.word,
    this.onStar,
    this.starred = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.translate, size: 20),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.word,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  word.meaning,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
                ),
                if (word.example.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    "“${word.example}”",
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: onStar,
            icon: Icon(starred ? Icons.star : Icons.star_border),
          ),
        ],
      ),
    );
  }
}
