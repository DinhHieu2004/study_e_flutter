import 'package:flutter/material.dart';

enum CourseCardStatus { normal, activePrimary, activeSecondary, done }

class CourseListItem extends StatelessWidget {
  final String imagePath;
  final String topic;
  final String title;
  final String description;
  final String level;
  final IconData actionIcon;
  final VoidCallback? onTap;
  final CourseCardStatus status;

  const CourseListItem({
    super.key,
    required this.imagePath,
    required this.topic,
    required this.title,
    required this.description,
    required this.level,
    this.actionIcon = Icons.chevron_right,
    this.onTap,
    this.status = CourseCardStatus.normal,
  });

  @override
  Widget build(BuildContext context) {
    const textGrey = Color(0xFF8A8A8A);

    final (
      Color borderColor,
      Color actionBgColor,
      Color actionIconColor,
    ) = switch (status) {
      CourseCardStatus.activePrimary => (
        const Color(0xFF2F6BFF),
        const Color(0xFF2F6BFF),
        Colors.white,
      ),
      CourseCardStatus.activeSecondary => (
        const Color(0xFFFF8A00),
        const Color(0xFFFF8A00),
        Colors.white,
      ),
      CourseCardStatus.normal => (
        const Color(0xFFE6E6E6),
        const Color(0xFFF2F3F5),
        Colors.black87,
      ),
      CourseCardStatus.done => (
        const Color(0xFF22C55E), 
        const Color(0xFFE9FBEF), 
        const Color(0xFF16A34A), 
      ),
    };

    final path = imagePath.trim();
    final isUrl = path.startsWith('http://') || path.startsWith('https://');

    Widget imageWidget;
    if (path.isEmpty) {
      imageWidget = Container(
        width: 80,
        height: 65,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, color: Colors.white70, size: 28),
      );
    } else if (isUrl) {
      imageWidget = Image.network(
        path,
        width: 80,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 65,
          color: Colors.grey.shade300,
          child: const Icon(
            Icons.broken_image,
            color: Colors.white70,
            size: 28,
          ),
        ),
      );
    } else {
      imageWidget = Image.asset(
        path,
        width: 80,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 65,
          color: Colors.grey.shade300,
          child: const Icon(
            Icons.broken_image,
            color: Colors.white70,
            size: 28,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
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
                  child: imageWidget,
                ),
                const SizedBox(height: 8),
                Text(
                  topic,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                    color: actionBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(actionIcon, size: 22, color: actionIconColor),
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
