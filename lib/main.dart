import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home_page.dart';
import 'pages/vocabulary_page.dart';
import 'pages/exercise_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "English App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainLayout(),
    );
  }
}

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
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,

            onTap: (index) {
              setState(() => _currentIndex = index);
            },

            items: [
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/bottom_btn1.png", width: 16),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/bottom_btn2.png", width: 16),
                label: "Learn",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/bottom_btn3.png", width: 16),
                label: "Quiz",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/bottom_btn4.png", width: 16),
                label: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/icons/ic_statistics.png",width: 16,height: 16,),
                label: "Statistical",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
