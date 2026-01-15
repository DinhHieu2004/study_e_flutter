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
    final path = imagePath?.trim();
    final isUrl = path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));

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
              child: (path == null || path.isEmpty)
                  ? const Icon(Icons.image, color: Colors.white70, size: 32)
                  : (isUrl
                      ? Image.network(
                          path,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 32,
                          ),
                        )
                      : Image.asset(
                          path,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 32,
                          ),
                        )),
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
