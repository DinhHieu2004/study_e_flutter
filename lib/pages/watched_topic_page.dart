import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/watched_topic_provider.dart';
import '../widgets/flash_card/flashcard_header.dart';
import '../widgets/flash_card/topic_card.dart';
import '../utils/app_colors.dart';
import 'flashcard_page.dart';

class WatchedTopicPage extends ConsumerStatefulWidget {
  const WatchedTopicPage({super.key});

  @override
  ConsumerState<WatchedTopicPage> createState() => _WatchedTopicPageState();
}

class _WatchedTopicPageState extends ConsumerState<WatchedTopicPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(watchedTopicProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(watchedTopicProvider);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlashcardHeader(
              title: 'Topic đã xem',
              onBack: () => Navigator.pop(context),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (topics) {
                  if (topics.isEmpty) {
                    return const Center(
                      child: Text(
                        'Chưa xem topic nào',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      int crossAxisCount = 2;
                      double maxGridWidth = width;

                      if (width >= 1100) {
                        crossAxisCount = 4;
                        maxGridWidth = 1100;
                      } else if (width >= 700) {
                        crossAxisCount = 3;
                        maxGridWidth = 900;
                      }

                      return Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxGridWidth),
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: topics.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.82,
                                ),
                            itemBuilder: (_, i) {
                              final topic = topics[i];

                              return TopicCard(
                                topic: topic,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FlashcardPage(
                                        lessonId: topic.id,
                                        title: topic.name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
