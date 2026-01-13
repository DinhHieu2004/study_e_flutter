import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word_vm.dart';
import '../providers/lesson_detail_provider.dart';
import '../providers/word_provider.dart';

import 'package:flutter_application_1/widgets/lessons/meta_pill.dart';
import 'package:flutter_application_1/widgets/words/word_row.dart';

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
  bool _dialogueExpanded = false;
  bool _descExpanded = false;

  bool _lessonFavorite = false;
  final Set<String> _starredWordIds = {};

  List<_DialogueLine> get _dialogue {
    switch (widget.lessonId) {
      case "l1":
        return const [
          _DialogueLine(speaker: "Mai", text: "Hi! Good morning."),
          _DialogueLine(speaker: "Nam", text: "Good morning! How are you?"),
          _DialogueLine(speaker: "Mai", text: "I'm good, thanks. And you?"),
          _DialogueLine(speaker: "Nam", text: "Great. Nice to see you!"),
          _DialogueLine(speaker: "Mai", text: "Nice to meet you, Nam."),
          _DialogueLine(speaker: "Nam", text: "Nice to meet you too."),
          _DialogueLine(speaker: "Mai", text: "See you later. Goodbye!"),
          _DialogueLine(speaker: "Nam", text: "Bye! Have a good day."),
          _DialogueLine(speaker: "Mai", text: "Let's meet again tomorrow morning."),
          _DialogueLine(speaker: "Nam", text: "Sure. See you!"),
        ];
      case "l2":
        return const [
          _DialogueLine(speaker: "Linh", text: "Hello! Are you new here?"),
          _DialogueLine(speaker: "Anna", text: "Yes, I am. Nice to meet you."),
          _DialogueLine(speaker: "Linh", text: "Nice to meet you too. I'm Linh."),
          _DialogueLine(speaker: "Anna", text: "I'm Anna. Thanks for saying hi!"),
          _DialogueLine(speaker: "Linh", text: "How are you today?"),
          _DialogueLine(speaker: "Anna", text: "I'm fine, thanks. And you?"),
          _DialogueLine(speaker: "Linh", text: "I'm good. See you later!"),
          _DialogueLine(speaker: "Anna", text: "See you!"),
          _DialogueLine(speaker: "Linh", text: "Have a good day!"),
        ];
      case "l3":
        return const [
          _DialogueLine(speaker: "Teacher", text: "Can you repeat that, please?"),
          _DialogueLine(speaker: "Student", text: "Sure. I said: 'I need help.'"),
          _DialogueLine(speaker: "Teacher", text: "Speak a little slower, please."),
          _DialogueLine(
            speaker: "Student",
            text: "Okay. I need help with this question.",
          ),
          _DialogueLine(speaker: "Teacher", text: "No problem. Let's do it together."),
          _DialogueLine(speaker: "Student", text: "Thank you so much!"),
          _DialogueLine(speaker: "Teacher", text: "You're welcome."),
        ];
      default:
        return const [
          _DialogueLine(speaker: "A", text: "This is a sample dialogue."),
          _DialogueLine(speaker: "B", text: "It helps test the UI layout."),
          _DialogueLine(speaker: "A", text: "Tap More... to expand."),
          _DialogueLine(speaker: "B", text: "Tap Less... to collapse."),
          _DialogueLine(speaker: "A", text: "We can highlight vocabulary words here."),
          _DialogueLine(speaker: "B", text: "And also test longer conversations."),
        ];
    }
  }

  void _showPracticeOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose practice mode",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              _OptionTile(
                title: "Flashcards",
                subtitle: "Flip cards and learn vocabulary.",
                onTap: () {
                  Navigator.pop(ctx);
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
              _OptionTile(
                title: "Quiz",
                subtitle: "Multiple choice questions.",
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExercisePage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openVocabularySheet(List<WordVm> words) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF7F8FC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      showDragHandle: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          builder: (ctx, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Vocabulary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        "${words.length} words",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: words.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final w = words[i];
                        final starred = _starredWordIds.contains(w.id);
                        return WordRow(
                          word: w,
                          starred: starred,
                          onStar: () {
                            setState(() {
                              if (starred) {
                                _starredWordIds.remove(w.id);
                              } else {
                                _starredWordIds.add(w.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Map<String, bool> _buildSpeakerSideMap(List<_DialogueLine> lines) {
    final map = <String, bool>{};
    bool nextRight = false;
    for (final l in lines) {
      if (!map.containsKey(l.speaker)) {
        map[l.speaker] = nextRight;
        nextRight = !nextRight;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F8FC);
    const textGrey = Color(0xFF8A8A8A);
    const primaryBlue = Color(0xFF0066FF);

    final description = ref.watch(lessonDescriptionProvider(widget.lessonId));
    final words = ref.watch(wordsByLessonProvider(widget.lessonId));

    final highlights = words.map((w) => w.word).toList(); 
    final dialogue = _dialogue;
    final speakerSide = _buildSpeakerSideMap(dialogue);

    const previewDialogueCount = 4;
    final showAllDialogue =
        _dialogueExpanded || dialogue.length <= previewDialogueCount;
    final showingDialogue =
        showAllDialogue ? dialogue : dialogue.take(previewDialogueCount).toList();

    final vocabPreview = words.take(3).map((e) => e.word).toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => setState(() => _lessonFavorite = !_lessonFavorite),
                  icon: Icon(
                    _lessonFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _lessonFavorite ? Colors.redAccent : Colors.black87,
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
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  MetaPill(icon: Icons.local_offer_rounded, text: widget.topic),
                  const SizedBox(width: 8),
                  MetaPill(icon: Icons.bar_chart_rounded, text: widget.level),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MetaPill(
                      icon: Icons.schedule_rounded,
                      text: "${widget.estMinutes} min",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.schedule_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Estimated time",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${widget.estMinutes} minutes",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFE9ECF2)),
                  const SizedBox(height: 10),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: _descExpanded ? null : 5,
                    overflow: _descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textGrey,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description.trim().length > 90)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => setState(() => _descExpanded = !_descExpanded),
                        child: Text(
                          _descExpanded ? "Less..." : "More...",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.chat_bubble_outline_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Dialogue",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Tap More to see the full conversation",
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...showingDialogue.map(
                    (l) => _DialogueRow(
                      line: l,
                      highlights: highlights,
                      isRight: speakerSide[l.speaker] ?? false,
                    ),
                  ),
                  if (dialogue.length > previewDialogueCount)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => setState(() => _dialogueExpanded = !_dialogueExpanded),
                        child: Text(
                          _dialogueExpanded ? "Less..." : "More...",
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _SectionCard(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openVocabularySheet(words),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Vocabulary in this lesson",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          "${words.length} words",
                          style: const TextStyle(
                            fontSize: 13,
                            color: textGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                    if (vocabPreview.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        vocabPreview.join(" • "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: textGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              width: double.infinity,
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

class _DialogueLine {
  final String speaker;
  final String text;
  const _DialogueLine({required this.speaker, required this.text});
}

class _DialogueRow extends StatelessWidget {
  final _DialogueLine line;
  final List<String> highlights;
  final bool isRight;

  const _DialogueRow({
    required this.line,
    required this.highlights,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _buildHighlightedSpans(
      "${line.speaker}: ",
      line.text,
      highlights,
      speakerStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Color(0xFF6B6B6B),
      ),
      normalStyle: const TextStyle(
        fontSize: 14,
        height: 1.35,
        color: Colors.black87,
      ),
      highlightStyle: const TextStyle(
        fontSize: 14,
        height: 1.35,
        color: Color(0xFF0066FF),
        fontWeight: FontWeight.w900,
      ),
    );

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isRight ? const Color(0xFFEAF2FF) : const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isRight ? 14 : 4),
          bottomRight: Radius.circular(isRight ? 4 : 14),
        ),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: RichText(text: TextSpan(children: spans)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [bubble],
      ),
    );
  }

  List<TextSpan> _buildHighlightedSpans(
    String speakerPrefix,
    String text,
    List<String> terms, {
    required TextStyle speakerStyle,
    required TextStyle normalStyle,
    required TextStyle highlightStyle,
  }) {
    final cleaned = terms
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    final result = <TextSpan>[
      TextSpan(text: speakerPrefix, style: speakerStyle),
    ];

    if (cleaned.isEmpty) {
      result.add(TextSpan(text: text, style: normalStyle));
      return result;
    }

    final escaped = cleaned.map(RegExp.escape).join("|");
    final reg = RegExp(escaped, caseSensitive: false);

    int last = 0;
    for (final m in reg.allMatches(text)) {
      if (m.start > last) {
        result.add(TextSpan(text: text.substring(last, m.start), style: normalStyle));
      }
      result.add(TextSpan(text: text.substring(m.start, m.end), style: highlightStyle));
      last = m.end;
    }
    if (last < text.length) {
      result.add(TextSpan(text: text.substring(last), style: normalStyle));
    }

    return result;
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF8A8A8A))),
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
