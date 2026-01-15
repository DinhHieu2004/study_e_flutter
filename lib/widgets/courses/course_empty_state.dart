import 'package:flutter/material.dart';

class CourseEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const CourseEmptyState({
    super.key,
    this.title = "No topics found",
    this.subtitle = "Try another keyword or filter.",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 46, color: Color(0xFF9AA0A6)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B), height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
