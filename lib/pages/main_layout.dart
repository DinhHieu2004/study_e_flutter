import 'package:flutter/material.dart';
import 'home_page.dart';
import 'vocabulary_page.dart';
import 'exercise_page.dart';
import 'profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    VocabularyPage(),
    ExercisePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Expanded(
            child: _pages[_currentIndex],
          ),

          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xffB4B4B4),
          ),

          // ========== Bottom Navigation ==========
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              onTap: (i) => setState(() => _currentIndex = i),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: "Từ vựng",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: "Bài tập",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Tôi",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
