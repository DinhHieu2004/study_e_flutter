import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/lesson_list_page.dart';
import 'package:flutter_application_1/widgets/courses/course_list_item.dart';
import '../widgets/courses/course_list_view.dart';
import '../widgets/courses/courses_filter_chips.dart';
import '../widgets/courses/courses_search_bar.dart';
import '../widgets/courses/courses_top_bar.dart';

class CoursesPage extends StatefulWidget {
  final VoidCallback? onClose;

  const CoursesPage({super.key, this.onClose});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final _searchCtl = TextEditingController();
  int _selectedChip = 0;

  final List<String> _chips = const ["All", "Beginner", "Intermediate", "Advanced"];

  late final List<CourseVm> _allCourses = [
    const CourseVm(
      imagePath: "assets/imgs/business.png",
      topic: "Business",
      title: "Economics Conversation",
      description: "Common phrases business major",
      level: "A1",
      lessonCount: 6,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    const CourseVm(
      imagePath: "assets/imgs/cafe.png",
      topic: "Travel & Coffee",
      title: "At the Cafe",
      description: "Order & small talk when hangout travel with friend",
      level: "A1",
      lessonCount: 5,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    const CourseVm(
      imagePath: "assets/imgs/film.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    const CourseVm(
      imagePath: "assets/imgs/friend.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.activePrimary,
      actionIcon: Icons.chevron_right,
    ),
    const CourseVm(
      imagePath: "assets/imgs/friend.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.normal,
      actionIcon: Icons.chevron_right,
    ),
    const CourseVm(
      imagePath: "assets/imgs/film.png",
      topic: "Working",
      title: "Office English",
      description: "Emails & meetings with colleagues in your company",
      level: "A2",
      lessonCount: 4,
      status: CourseCardStatus.activeSecondary,
      actionIcon: Icons.chevron_right,
    ),
  ];

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  List<CourseVm> _filterCourses() {
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

    return _allCourses.where((c) => matchChip(c) && matchQuery(c)).toList();
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
    final courses = _filterCourses();

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
