import 'package:flutter/material.dart';

class CoursesTopBar extends StatelessWidget {
  final VoidCallback? onClose;
  final String title;

  const CoursesTopBar({
    super.key,
    this.onClose,
    this.title = "Lesson with topics",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onClose ?? () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.tune_rounded, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
