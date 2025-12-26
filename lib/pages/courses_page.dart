import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import '../models/course_vm.dart';
import '../widgets/courses/course_list_view.dart';
import '../widgets/courses/courses_filter_chips.dart';
import '../widgets/courses/courses_search_bar.dart';
import '../widgets/courses/courses_top_bar.dart';
import 'lesson_list_page.dart';

class CoursesPage extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  const CoursesPage({super.key, this.onClose});

  @override
  ConsumerState<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  final _searchCtl = TextEditingController();
  int _selectedChip = 0;

  final List<String> _chips = const ["All", "Beginner", "Intermediate", "Advanced"];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<CourseVm> _filterCourses(List<CourseVm> all) {
    final q = _searchCtl.text.trim().toLowerCase();

    bool matchChip(CourseVm c) {
      if (_selectedChip == 0) return true; // All
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

  void _openCourse(CourseVm c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonListPage(
          courseTitle: c.title,
          courseLevel: c.level,
          courseImageAsset: c.imagePath,
          totalLessons: c.lessonCount,
          doneLessons: 0,
          estMinutes: c.lessonCount * 7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCourses = ref.watch(courseListProvider);
    final courses = _filterCourses(allCourses);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CoursesTopBar(onClose: widget.onClose, title: "Courses"),
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
              child: CourseListView(
                courses: courses,
                onCourseTap: _openCourse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
