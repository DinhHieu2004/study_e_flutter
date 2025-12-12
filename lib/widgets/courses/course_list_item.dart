import 'package:flutter/material.dart';

class CourseListItem extends StatelessWidget {
  final String imagePath;
  final String topic;
  final String title;
  final String description;
  final String level;
  final IconData actionIcon;
  final VoidCallback? onTap;

  const CourseListItem({
    super.key,
    required this.imagePath,
    required this.topic,
    required this.title,
    required this.description,
    required this.level,
    this.actionIcon = Icons.chevron_right,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE6E6E6);
    const textGrey = Color(0xFF8A8A8A);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(actionIcon, size: 22, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                level,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
