import 'package:flutter/material.dart';
import 'meta_pill.dart';

class LessonCourseHeader extends StatelessWidget {
  final String title;
  final String level;
  final String imageAsset;
  final int totalLessons;
  final int doneLessons;
  final int estMinutes;
  final VoidCallback onBack;

  const LessonCourseHeader({
    super.key,
    required this.title,
    required this.level,
    required this.imageAsset,
    required this.totalLessons,
    required this.doneLessons,
    required this.estMinutes,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onBack,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(Icons.arrow_back, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF2F3F5),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, color: Color(0xFF9AA0A6)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MetaPill(icon: Icons.school_outlined, text: "Level $level"),
              MetaPill(
                icon: Icons.menu_book_outlined,
                text: "$doneLessons/$totalLessons lessons",
              ),
              MetaPill(
                icon: Icons.timer_outlined,
                text: estMinutes > 0 ? "~$estMinutes min" : "Self-paced",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
