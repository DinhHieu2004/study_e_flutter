import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_detail_provider.dart';
import 'package:flutter_application_1/widgets/lessons/meta_pill.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'exercise_page.dart';
import 'flashcard_practice_page.dart';
import 'package:just_audio/just_audio.dart';
import '../models/vocabulary_response.dart';

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
  static const int _dialogueStep = 4;
  int _dialogueVisibleCount = _dialogueStep;
  final AudioPlayer _wordPlayer = AudioPlayer();
  int? _playingVocabId;

  bool _lessonFavorite = false;
  final Set<int> _starredVocabIds = {};

  @override
  void didUpdateWidget(covariant LessonDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      _dialogueVisibleCount = _dialogueStep;
    }
  }

  @override
  void dispose() {
    _wordPlayer.dispose();
    super.dispose();
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

  void _openVocabularySheet(List<dynamic> vocabs) {
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
                        "${vocabs.length} words",
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
                      itemCount: vocabs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final v = vocabs[i];
                        final int id = (v.id as num).toInt();
                        final bool starred = _starredVocabIds.contains(id);

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE9ECF2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              v.word ?? "",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          if ((v.phonetic ?? "")
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                            Text(
                                              v.phonetic,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF8A8A8A),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        v.meaning ?? "",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.35,
                                          color: Color(0xFF6B6B6B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if ((v.example ?? "")
                                          .toString()
                                          .trim()
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          v.example,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            height: 1.35,
                                            color: Color(0xFF8A8A8A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (starred) {
                                        _starredVocabIds.remove(id);
                                      } else {
                                        _starredVocabIds.add(id);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    starred
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: starred
                                        ? const Color(0xFFFFB300)
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildCover(String path) {
    final p = path.trim();
    final isUrl = p.startsWith('http://') || p.startsWith('https://');

    if (p.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }

    return isUrl
        ? Image.network(
            p,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          )
        : Image.asset(
            p,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F8FC);
    const textGrey = Color(0xFF8A8A8A);
    const primaryBlue = Color(0xFF0066FF);

    final dataAsync = ref.watch(lessonDetailDataProvider(widget.lessonId));

    return dataAsync.when(
      loading: () => const Scaffold(
        backgroundColor: bg,
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Load lesson detail error: $e"),
            ),
          ),
        ),
      ),
      data: (data) {
        final lesson = data.lesson;
        final dialogs = data.dialogs;
        final vocabs = data.vocabularies;

        final pageTitle = (lesson.title.trim().isNotEmpty)
            ? lesson.title
            : widget.title;
        final topicName = (lesson.topicName.trim().isNotEmpty)
            ? lesson.topicName
            : widget.topic;
        final level = (lesson.level.trim().isNotEmpty)
            ? lesson.level
            : widget.level;
        final description = (lesson.description.trim().isNotEmpty)
            ? lesson.description
            : "No description.";

        final coverPath = (lesson.imageUrl ?? "").toString().trim().isNotEmpty
            ? lesson.imageUrl.toString()
            : widget.imageAsset;

        final highlights = vocabs
            .map((v) => (v.word ?? "").toString().trim())
            .where((w) => w.isNotEmpty)
            .toList();

        final dialogue = dialogs
            .map<_DialogueLine>(
              (d) => _DialogueLine(
                speaker: (d.speaker ?? "").toString(),
                text: (d.content ?? "").toString(),
              ),
            )
            .where(
              (l) => l.speaker.trim().isNotEmpty || l.text.trim().isNotEmpty,
            )
            .toList();

        final speakerSide = _buildSpeakerSideMap(dialogue);

        const previewDialogueCount = _dialogueStep;

        final int shown = _dialogueVisibleCount.clamp(0, dialogue.length);
        final showingDialogue = dialogue.take(shown).toList();

        final bool isAllShown = shown >= dialogue.length;
        final int remaining = dialogue.length - shown;

        final vocabPreview = vocabs
            .take(3)
            .map((e) => (e.word ?? "").toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();

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
                        pageTitle,
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
                      onPressed: () =>
                          setState(() => _lessonFavorite = !_lessonFavorite),
                      icon: Icon(
                        _lessonFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _lessonFavorite
                            ? Colors.redAccent
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Builder(
                  builder: (_) {
                    final mediaUrl = (lesson.audioUrl ?? "").trim();
                    final hasMp4 = mediaUrl.toLowerCase().endsWith(".mp4");

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: hasMp4
                            ? _LessonVideoCover(url: mediaUrl)
                            : _buildCover(coverPath),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MetaPill(
                        icon: Icons.local_offer_rounded,
                        text: topicName,
                      ),
                      const SizedBox(width: 8),
                      MetaPill(icon: Icons.bar_chart_rounded, text: level),
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textGrey,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
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

                      if (showingDialogue.isEmpty)
                        const Text(
                          "No dialogue yet.",
                          style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else
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
                            onPressed: () {
                              setState(() {
                                if (isAllShown) {
                                  _dialogueVisibleCount = _dialogueStep;
                                } else {
                                  _dialogueVisibleCount =
                                      (shown + _dialogueStep).clamp(
                                        0,
                                        dialogue.length,
                                      );
                                }
                              });
                            },
                            child: Text(
                              isAllShown
                                  ? "Less..."
                                  : "More... (+${remaining >= _dialogueStep ? _dialogueStep : remaining})",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
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
                    onTap: () => _openVocabularySheet(vocabs),
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
                              "${vocabs.length} words",
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        mainAxisAlignment: isRight
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
    final cleaned =
        terms.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList()
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
        result.add(
          TextSpan(text: text.substring(last, m.start), style: normalStyle),
        );
      }
      result.add(
        TextSpan(text: text.substring(m.start, m.end), style: highlightStyle),
      );
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

class _LessonVideoCover extends StatefulWidget {
  final String url;
  const _LessonVideoCover({required this.url});

  @override
  State<_LessonVideoCover> createState() => _LessonVideoCoverState();
}

class _LessonVideoCoverState extends State<_LessonVideoCover>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  Object? _err;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant _LessonVideoCover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _setup();
  }

  Future<void> _setup() async {
    _err = null;

    try {
      await _chewieCtrl?.pause();
    } catch (_) {}

    _chewieCtrl?.dispose();
    _chewieCtrl = null;

    await _videoCtrl?.dispose();
    _videoCtrl = null;

    try {
      final vc = VideoPlayerController.networkUrl(Uri.parse(widget.url.trim()));
      _videoCtrl = vc;

      await vc.initialize();
      vc.setLooping(false);
      vc.setVolume(1.0);

      _chewieCtrl = ChewieController(
        videoPlayerController: vc,
        autoPlay: false,
        looping: false,
        showControls: true,
        allowFullScreen: false,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
      );

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) setState(() => _err = e);
    }
  }

  @override
  void dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_err != null) {
      return Center(child: Text("Không phát được media: $_err"));
    }
    if (_chewieCtrl == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Chewie(controller: _chewieCtrl!);
  }
}
