import 'package:flutter/material.dart';
import 'lesson_status.dart';

class LessonRow extends StatelessWidget {
  final String thumbAsset;
  final String title;
  final String subtitle;
  final LessonStatus status;
  final VoidCallback? onTap;
  final VoidCallback onMore;

  const LessonRow({
    super.key,
    required this.thumbAsset,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final bool locked = status == LessonStatus.locked;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: locked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E6E6), width: 1.1),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 54,
                height: 54,
                color: const Color(0xFFF2F3F5),
                child: Image.asset(
                  thumbAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, color: Color(0xFF9AA0A6)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: locked ? const Color(0xFF9AA0A6) : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RightStatusButton(status: status),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onMore,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.more_horiz, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RightStatusButton extends StatelessWidget {
  final LessonStatus status;
  const _RightStatusButton({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color bg;
    Color fg;

    switch (status) {
      case LessonStatus.done:
        icon = Icons.check;
        bg = const Color(0xFF23B26D);
        fg = Colors.white;
        break;
      case LessonStatus.available:
        icon = Icons.play_arrow_rounded;
        bg = const Color(0xFF2F6BFF);
        fg = Colors.white;
        break;
      case LessonStatus.locked:
        icon = Icons.lock;
        bg = const Color(0xFFF2F3F5);
        fg = const Color(0xFF9AA0A6);
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: fg),
    );
  }
}
