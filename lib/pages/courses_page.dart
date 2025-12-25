import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_provider.dart';
import 'lesson_list_page.dart';
import '../widgets/courses/course_list_view.dart';
import '../widgets/courses/courses_filter_chips.dart';
import '../widgets/courses/courses_search_bar.dart';
import '../widgets/courses/courses_top_bar.dart';
import '../models/course_vm.dart';

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
      if (label == "beginner") return c.level.toLowerCase().startsWith("a");
      if (label == "intermediate") return c.level.toLowerCase().startsWith("b");
      if (label == "advanced") return c.level.toLowerCase().startsWith("c");
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

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onClose,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Courses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: "Search course name...",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_query.isNotEmpty)
            InkWell(
              onTap: () {
                _searchController.clear();
                setState(() => _query = "");
              },
              child: const Icon(Icons.close, size: 18, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.black : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _CourseData {
  final String imagePath;
  final String topic;
  final String title;
  final String description;
  final String level;
  final IconData actionIcon;
  final CourseCardStatus status;
  final int lessonCount;

  const _CourseData({
    required this.imagePath,
    required this.topic,
    required this.title,
    required this.description,
    required this.level,
    required this.lessonCount,
    this.actionIcon = Icons.arrow_forward,
    
    this.status = CourseCardStatus.normal,
  });
}

