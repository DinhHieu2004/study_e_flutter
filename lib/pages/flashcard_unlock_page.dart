import 'package:flutter/material.dart';
import '../models/unlockable_flashcard.dart';
import '../repositories/flashcard_repository.dart';
import '../widgets/flash_card/lock_flashcard_tile.dart';
import '../widgets/flash_card/unlocked_flashcard_tile.dart';
import '../widgets/flash_card/card_split_overlay.dart';

class FlashcardUnlockPage extends StatefulWidget {
  final int topicId;
  final String title;

  const FlashcardUnlockPage({
    super.key,
    required this.topicId,
    required this.title,
  });

  @override
  State<FlashcardUnlockPage> createState() => _FlashcardUnlockPageState();
}

class _FlashcardUnlockPageState extends State<FlashcardUnlockPage> {
  final ScrollController _scrollController = ScrollController();
  final FlashcardRepository _repo = FlashcardRepository();

  bool _loading = true;
  List<UnlockableFlashcard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final data = await _repo.getByTopic(widget.topicId);
    setState(() {
      _cards = data;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;

                        int crossAxisCount = 2;
                        if (width >= 1000) {
                          crossAxisCount = 5;
                        } else if (width >= 800) {
                          crossAxisCount = 4;
                        } else if (width >= 600) {
                          crossAxisCount = 3;
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          itemCount: _cards.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.66,
                              ),
                          itemBuilder: (_, i) => _buildCard(_cards[i]),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCard(UnlockableFlashcard card) {
    final bool canTap = !card.unlocked;

    return _HoverCard(
      onTap: canTap
          ? () async {
              final result = await showCardSplitOverlay(
                context,
                cardId: card.id,
              );

              if (result != null) {
                setState(() {
                  final index = _cards.indexWhere((c) => c.id == card.id);
                  if (index != -1) {
                    _cards[index] = result;
                  }
                });
              }
            }
          : null,
      child: card.unlocked
          ? UnlockedFlashcardTile(
              word: card.word!,
              phonetic: card.phonetic,
              imageUrl: card.imageUrl,
            )
          : const LockedFlashcardTile(),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _HoverCard({required this.child, this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _hovered ? -3 : 0.0)
            ..scale(_hovered ? 1.02 : 1.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: widget.child,
        ),
      ),
    );
  }
}
