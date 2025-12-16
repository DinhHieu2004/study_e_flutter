import 'package:flutter/material.dart';

class MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const MetaPill({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B6B6B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}
