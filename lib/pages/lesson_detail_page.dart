import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/lesson_detail_provider.dart';
import 'exercise_page.dart';
import 'flashcard_practice_page.dart';

class LessonDetailPage extends ConsumerStatefulWidget {
  final String lessonId;
  final String title;

  final String imageAsset;
  final String topic;
  final String level;
  final int estMinutes;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
    required this.title,
    required this.imageAsset,
    required this.topic,
    required this.level,
    required this.estMinutes,
  });

  @override
  ConsumerState<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends ConsumerState<LessonDetailPage> {
  bool _expanded = false;

  List<_DialogueLine> get _dialogue {
    switch (widget.lessonId) {
      case "l1":
        return const [
          _DialogueLine(speaker: "Mai", text: "Hi! Good morning."),
          _DialogueLine(speaker: "Nam", text: "Good morning! How are you?"),
          _DialogueLine(speaker: "Mai", text: "I'm good, thanks. And you?"),
          _DialogueLine(speaker: "Nam", text: "Great. Nice to see you!"),
        ];
      case "l2":
        return const [
          _DialogueLine(speaker: "Linh", text: "Hello! Are you new here?"),
          _DialogueLine(speaker: "Anna", text: "Yes, I am. Nice to meet you."),
          _DialogueLine(
            speaker: "Linh",
            text: "Nice to meet you too. I'm Linh.",
          ),
          _DialogueLine(
            speaker: "Anna",
            text: "I'm Anna. Thanks for saying hi!",
          ),
        ];
      case "l3":
        return const [
          _DialogueLine(
            speaker: "Minh",
            text: "Hi, I'm Minh. What's your name?",
          ),
          _DialogueLine(speaker: "Tom", text: "I'm Tom. Nice to meet you."),
          _DialogueLine(speaker: "Minh", text: "Where are you from?"),
          _DialogueLine(
            speaker: "Tom",
            text: "I'm from Canada. How about you?",
          ),
        ];
      case "l4":
        return const [
          _DialogueLine(
            speaker: "Teacher",
            text: "Can you repeat that, please?",
          ),
          _DialogueLine(
            speaker: "Student",
            text: "Sure. I said: 'I need help.'",
          ),
          _DialogueLine(
            speaker: "Teacher",
            text: "Speak a little slower, please.",
          ),
          _DialogueLine(
            speaker: "Student",
            text: "Okay. I need help with this question.",
          ),
        ];
      case "l5":
        return const [
          _DialogueLine(speaker: "A", text: "Excuse me, is this seat taken?"),
          _DialogueLine(speaker: "B", text: "No, go ahead."),
          _DialogueLine(speaker: "A", text: "Thanks. By the way, I'm Alex."),
          _DialogueLine(speaker: "B", text: "Nice to meet you, Alex. I'm Sam."),
        ];
      case "l6":
        return const [
          _DialogueLine(
            speaker: "Shopkeeper",
            text: "That will be fifteen dollars.",
          ),
          _DialogueLine(speaker: "Customer", text: "Sorry—how much is it?"),
          _DialogueLine(speaker: "Shopkeeper", text: "Fifteen. One-five."),
          _DialogueLine(speaker: "Customer", text: "Got it. Here’s twenty."),
        ];
      default:
        return const [
          _DialogueLine(speaker: "A", text: "Hello!"),
          _DialogueLine(speaker: "B", text: "Hi! Nice to meet you."),
          _DialogueLine(speaker: "A", text: "Nice to meet you too."),
        ];
    }
  }

  void _showPracticeOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose practice mode",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),

                _PracticeTile(
                  icon: Icons.style_rounded,
                  title: "Flashcards",
                  subtitle: "Review words by flipping cards",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FlashcardPracticePage(
                          lessonId: widget.lessonId,
                          title: "${widget.title} • Flashcards",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                _PracticeTile(
                  icon: Icons.quiz_rounded,
                  title: "Quiz",
                  subtitle: "Test your memory with quick questions",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExercisePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F8FC);
    const border = Color(0xFFE9ECF2);
    const textGrey = Color(0xFF8A8A8A);
    const primaryBlue = Color(0xFF0066FF);

    final description = ref.watch(lessonDescriptionProvider(widget.lessonId));
    final dialogue = _dialogue;
    final previewCount = 4;
    final showAll = _expanded || dialogue.length <= previewCount;
    final showing = showAll ? dialogue : dialogue.take(previewCount).toList();

    return Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 44,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _Pill(text: widget.topic),
                const SizedBox(width: 8),
                _Pill(text: widget.level),
              ],
            ),
            const SizedBox(height: 14),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textGrey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    "Estimated time",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${widget.estMinutes} minutes",
                    style: const TextStyle(fontSize: 14, color: textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dialogue",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  ...showing.map(
                    (l) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _DialogueRow(line: l),
                    ),
                  ),
                  if (dialogue.length > previewCount)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => setState(() => _expanded = !_expanded),
                        child: Text(
                          _expanded ? "Less..." : "More...",
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _showPracticeOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Practice",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _DialogueRow extends StatelessWidget {
  final _DialogueLine line;
  const _DialogueRow({required this.line});

  @override
  Widget build(BuildContext context) {
    const textGrey = Color(0xFF8A8A8A);
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, height: 1.35, color: Colors.black),
        children: [
          TextSpan(
            text: "${line.speaker}: ",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: textGrey,
            ),
          ),
          TextSpan(text: line.text),
        ],
      ),
    );
  }
}

class _DialogueLine {
  final String speaker;
  final String text;
  const _DialogueLine({required this.speaker, required this.text});
}

class _PracticeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PracticeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9ECF2)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
