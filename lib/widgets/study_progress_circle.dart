import 'package:flutter/material.dart';

class StudyProgressCircle extends StatelessWidget {
  final double size;
  final double progress;
  final double strokeWidth;
  final Color color;
  final Widget child;

  const StudyProgressCircle({
    super.key,
    required this.size,
    required this.progress,
    required this.child,
    this.strokeWidth = 12,
    this.color = const Color(0xFF0066FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: const Color(0xFFE6ECF7),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),

          Container(
            width: size - strokeWidth * 3,  
            height: size - strokeWidth * 3,
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}
