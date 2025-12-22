import 'package:flutter_riverpod/flutter_riverpod.dart';

final lessonDescriptionProvider =
    Provider.family<String, String>((ref, lessonId) {
  switch (lessonId) {
    case "l1":
      return "Learn common greetings used in daily conversations.";
    case "l2":
      return "Practice saying hello and starting a simple conversation.";
    case "l3":
      return "Introduce yourself and ask about others.";
    case "l4":
      return "Learn how to communicate clearly and ask for clarification.";
    case "l5":
      return "Practice opening a conversation in different situations.";
    case "l6":
      return "Learn how to say and understand numbers in daily life.";
    default:
      return "Learn useful vocabulary through short dialogues.";
  }
});
