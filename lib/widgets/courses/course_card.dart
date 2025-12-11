import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String? imagePath;

  const CourseCard({
    super.key,
    required this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey.shade300,
              child: imagePath == null
                  ? const Icon(Icons.image, color: Colors.white70, size: 32)
                  : Image.asset(imagePath!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
