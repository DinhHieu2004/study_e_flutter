import 'package:flutter/material.dart';

class LockedFlashcardTile extends StatelessWidget {
  final bool large;

  const LockedFlashcardTile({super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    final double borderRadius = large ? 22 : 12;
    final double fontSize = large ? 72 : 48;
    final double borderWidth = large ? 1.5 : 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade300, width: borderWidth),
        boxShadow: large
            ? const [
                BoxShadow(
                  blurRadius: 18,
                  color: Colors.black26,
                  offset: Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          "?",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
