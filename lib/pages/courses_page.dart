import 'package:flutter/material.dart';
import '../../widgets/courses/course_list_item.dart';
import '../pages/lesson_list_page.dart';

class CoursesPage extends StatefulWidget {
  final VoidCallback? onClose;

  const CoursesPage({super.key, this.onClose});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = "";
  int _selectedChip = 0;

  final List<_CourseData> _allCourses = const [
    _CourseData(
      imagePath: "assets/imgs/lifestyle.png",
      topic: "Business",
      title: "In Court",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "A1 - A2",
      status: CourseCardStatus.normal,
      lessonCount: 4,
    ),
    _CourseData(
      imagePath: "assets/imgs/business.png",
      topic: "Lifestyle",
      title: "Sport",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "A1 - A2",
      status: CourseCardStatus.normal,
      lessonCount: 5,
    ),
    _CourseData(
      imagePath: "assets/imgs/film.png",
      topic: "Lifestyle",
      title: "Weather",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "A1 - A2",
      status: CourseCardStatus.normal,
      lessonCount: 4,
    ),
    _CourseData(
      imagePath: "assets/imgs/cafe.png",
      topic: "Cafe",
      title: "Cafe shop",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "A1 - A2",
      status: CourseCardStatus.activePrimary,
      lessonCount: 3,
    ),
    _CourseData(
      imagePath: "assets/imgs/hangout.png",
      topic: "Hangout",
      title: "Shopping mall",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "B1 - B2",
      status: CourseCardStatus.normal,
      lessonCount: 5,
    ),
    _CourseData(
      imagePath: "assets/imgs/music.png",
      topic: "Music",
      title: "Relaxing",
      description: "Lorem Ipsum is simply dummy text of the prin...",
      level: "C1 - C2",
      status: CourseCardStatus.activeSecondary,
      lessonCount: 4,
    ),
  ];

  final List<String> _chips = const [
    "All",
    "Business",
    "Lifestyle",
    "Lesson 0",
    "A1-A2",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CourseData> get _filteredCourses {
    final q = _query.trim().toLowerCase();

    return _allCourses.where((c) {
      final chip = _chips[_selectedChip];
      final bool passChip = switch (chip) {
        "All" => true,
        "A1-A2" => c.level.toLowerCase().contains("a1"),
        _ => c.topic.toLowerCase() == chip.toLowerCase(),
      };

      final bool passQuery = q.isEmpty
          ? true
          : c.title.toLowerCase().contains(q);

      return passChip && passQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _chips.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = index == _selectedChip;
                  return _FilterChip(
                    label: _chips[index],
                    selected: selected,
                    onTap: () => setState(() => _selectedChip = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final c = courses[i];
                  return CourseListItem(
                    imagePath: c.imagePath,
                    topic: c.topic,
                    title: c.title,
                    description: c.description,
                    level: c.level,
                    status: c.status,
                    actionIcon: c.actionIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LessonListPage(
                            courseTitle: "In Court",
                            courseLevel: "A1-A2",
                            courseImageAsset: "assets/imgs/lifestyle.png",
                            totalLessons: 6,
                            doneLessons: 4,
                            estMinutes: 120,
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