import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/flash_card_provider.dart';
import '../widgets/flash_card/flashcard_header.dart';
import '../widgets/flash_card/flashcard_item.dart';

class FlashcardPage extends ConsumerStatefulWidget {
  final int lessonId;
  final String title;

  const FlashcardPage({super.key, required this.lessonId, required this.title});

  @override
  ConsumerState<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  final PageController _controller = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(flashcardProvider.notifier).load(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8EEAC),
      body: SafeArea(
        child: Column(
          children: [
            FlashcardHeader(
              title: widget.title,
              onBack: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),

            if (state.loading)
              const CircularProgressIndicator()
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;

                  return SizedBox(
                    height: isDesktop ? 420 : 300,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: state.cards.length,
                      onPageChanged: (i) =>
                          ref.read(flashcardProvider.notifier).setIndex(i),
                      itemBuilder: (_, i) => Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop
                                ? 420
                                : constraints.maxWidth * 0.85,
                          ),
                          child: FlashcardItem(card: state.cards[i]),
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 8),
            Text(
              '${state.index + 1} / ${state.cards.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read(flashcardProvider.notifier).next();
                _controller.animateToPage(
                  ref.read(flashcardProvider).index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
