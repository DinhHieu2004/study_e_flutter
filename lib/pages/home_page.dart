import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import '../widgets/lessons/lesson_card.dart';
import '../widgets/videos/video_card.dart';
import '../widgets/study_progress_circle.dart';
import '../widgets/courses/course_card.dart';
import 'lessons_page.dart';
import '../screens/camera_detector_screen.dart';
import 'dictionary_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _openLessonsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LessonsPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildDictionarySearch(context),
              const SizedBox(height: 24),
              _buildStudyCard(context),
              const SizedBox(height: 16),
              _buildPromoBanner(),
              const SizedBox(height: 24),
              _buildCoursesSection(context, ref),
              const SizedBox(height: 24),
              _buildUserExperienceSection(),
              const SizedBox(height: 24),
              _buildRecommendedLessonSection(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('name');
    if (name != null && name.trim().isNotEmpty) {
      return name;
    }

    final email = prefs.getString('email');
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'User';
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: getDisplayName(),
              builder: (context, snapshot) {
                final displayName = snapshot.data ?? 'User';

                return Text(
                  'Hi, $displayName',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              "Let’s start learning!",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // Bọc các icon trong một Row
        Row(
          children: [
            // NÚT SCAN MỚI THÊM
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraDetectorScreen(),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
            ),

            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDictionarySearch(BuildContext context) {
    final controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search dictionary...",
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.primaryBlue),
        ),
        onSubmitted: (word) {
          final trimmed = word.trim();
          if (trimmed.isEmpty) return;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DictionaryPage(word: trimmed)),
          );
        },
      ),
    );
  }

  Widget _buildStudyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "How many hours you studied this week",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    onPressed: () {
                      _openLessonsPage(context);
                    },
                    child: const Text(
                      "Let's start",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          StudyProgressCircle(
            size: 100,
            progress: 0.6,
            strokeWidth: 10,
            child: const Text(
              "2h 15m",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentOrange,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Special offer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Get 50% off SpeakUp Premium and unlock all lessons.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "View",
              style: TextStyle(
                color: AppColors.accentOrange,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(homeCoursesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Lessons with topics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            InkWell(
              onTap: () => _openLessonsPage(context),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        coursesState.when(
          loading: () => const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Error: $e'),
          ),
          data: (courses) {
            final displayCourses = courses.take(6).toList();

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: displayCourses.length,
                itemBuilder: (context, index) {
                  final course = displayCourses[index];

                  return CourseCard(
                    title: course.title,
                    imagePath: course.imagePath,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "User experience video",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              VideoCard(
                name: "Amanda roch",
                isPrimary: true,
                imagePath: "assets/imgs/amanda.png",
              ),
              SizedBox(width: 12),
              VideoCard(
                name: "Tarkan orhan",
                isPrimary: false,
                imagePath: "assets/imgs/tarkan.png",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedLessonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Recommended lesson",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              LessonCard(
                title: "How to Conversation\nwith your Friends",
                subtitle: "Cafe vocabulary",
                imagePath: "assets/imgs/cafe.png",
              ),
              SizedBox(width: 12),
              LessonCard(
                title: "Business small talk",
                subtitle: "Office conversation",
                imagePath: "assets/imgs/office.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
