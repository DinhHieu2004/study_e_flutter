import 'package:flutter/material.dart';

class FlashcardPracticePage extends StatelessWidget {
  final String lessonId;
  final String title;

  const FlashcardPracticePage({
    super.key,
    required this.lessonId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: Text("Flashcards for lesson: $lessonId"),
      ),
    );
  }
}
