import 'package:flutter/material.dart';

class LessonProgressLine extends StatelessWidget {
  final int doneLessons;
  final int totalLessons;

  const LessonProgressLine({
    super.key,
    required this.doneLessons,
    required this.totalLessons,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        totalLessons == 0 ? 0.0 : (doneLessons / totalLessons).clamp(0.0, 1.0);
    final int percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Course progress: $percent%",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFF2F3F5),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "$doneLessons of $totalLessons lessons completed",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A8A8A),
          ),
        ),
      ],
    );
  }
}
