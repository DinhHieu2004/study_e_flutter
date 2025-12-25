import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class VideoCard extends StatelessWidget {
  final String name;
  final bool isPrimary;
  final String? imagePath;

  const VideoCard({
    super.key,
    required this.name,
    this.isPrimary = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFC727);

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 110,
            color: yellow,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.orange,
                    ),
                  ),
                ),
                if (imagePath == null)
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  )
                else
                  Positioned(
                    right: 0,
                    bottom: 0, 
                    child: Image.asset(
                      imagePath!,
                      height: 110, 
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Let's go",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
