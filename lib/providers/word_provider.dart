import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word_vm.dart';

final wordsByLessonProvider = Provider.family<List<WordVm>, String>((ref, lessonId) {
  if (lessonId == "l1") {
    return const [
      WordVm(
        id: "w1",
        word: "hello",
        meaning: "xin chào",
        example: "Hello! Nice to meet you.",
        ipa: "/həˈləʊ/",
      ),
      WordVm(
        id: "w2",
        word: "good morning",
        meaning: "chào buổi sáng",
        example: "Good morning, teacher!",
      ),
      WordVm(
        id: "w3",
        word: "nice to meet you",
        meaning: "rất vui được gặp bạn",
        example: "Nice to meet you, too.",
      ),
    ];
  }

  return const [
    WordVm(
      id: "w0",
      word: "sample",
      meaning: "ví dụ",
      example: "This is a sample word.",
    ),
  ];
});
