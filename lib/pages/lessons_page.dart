import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_vm.dart';
import '../providers/lessons_provider.dart';
import '../widgets/courses/course_card.dart';
import '../widgets/courses/course_list_view.dart';
import '../widgets/courses/courses_filter_chips.dart';
import '../widgets/courses/courses_search_bar.dart';
import '../widgets/courses/courses_top_bar.dart';

class LessonsPage extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  const LessonsPage({super.key, this.onClose});

  @override
  ConsumerState<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends ConsumerState<LessonsPage> {
  final _searchCtl = TextEditingController();
  int _selectedChip = 0;

  final List<String> _chips = const [
    "All",
    "Beginner",
    "Intermediate",
    "Advanced",
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<CourseVm> _filterCourses(List<CourseVm> all) {
    final q = _searchCtl.text.trim().toLowerCase();

    bool matchChip(CourseVm c) {
      if (_selectedChip == 0) return true;
      final label = _chips[_selectedChip].toLowerCase();

      final lv = c.level.toLowerCase();
      if (label == "beginner") return lv.startsWith("a");
      if (label == "intermediate") return lv.startsWith("b");
      if (label == "advanced") return lv.startsWith("c");
      return true;
    }

    bool matchQuery(CourseVm c) {
      if (q.isEmpty) return true;
      return c.title.toLowerCase().contains(q) ||
          c.topic.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.level.toLowerCase().contains(q);
    }

    return all.where((c) => matchChip(c) && matchQuery(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(topicsProvider);
    final selectedTopicId = ref.watch(selectedTopicIdProvider);

    final lessonsAsync = ref.watch(lessonsBySelectedTopicProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CoursesTopBar(
              onClose: widget.onClose,
              title: "Lessons with topics",
            ),
            const SizedBox(height: 8),

            topicsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text("Load topics error: $e"),
              ),
              data: (topics) {
                if (selectedTopicId == null && topics.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(selectedTopicIdProvider.notifier).state =
                        topics.first.id;
                  });
                }
                return const SizedBox.shrink(); 
              },
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CoursesSearchBar(
                controller: _searchCtl,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchCtl.clear();
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 10),

            CoursesFilterChips(
              chips: _chips,
              selectedIndex: _selectedChip,
              onSelected: (i) => setState(() => _selectedChip = i),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: lessonsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Load lessons error: $e")),
                data: (all) {
                  final courses = _filterCourses(all);
                  return CourseListView(
                    courses: courses,
                    onCourseTap: (c) {
                      debugPrint("Tap lesson: ${c.title}");
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
