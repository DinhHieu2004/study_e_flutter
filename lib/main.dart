import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ĐÃ ĐỔI

import 'pages/home_page.dart';
import 'pages/vocabulary_page.dart';
import 'pages/exercise_page.dart';
import 'pages/profile_page.dart';
import 'controllers/quiz_controller.dart'; // Vẫn giữ controller

// KHAI BÁO PROVIDER VỚI RIVERPOD
// Sử dụng ChangeNotifierProvider để quản lý QuizController (được kế thừa từ ChangeNotifier)
final quizControllerProvider = ChangeNotifierProvider<QuizController>((ref) {
  return QuizController();
});


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLayout(),
    );
  }
}

// =========================================================================
void main() {
  // BẮT BUỘC BỌC ỨNG DỤNG BẰNG ProviderScope
  runApp(
    const ProviderScope( // <--- BƯỚC CẦN THIẾT CHO RIVERPOD
      child: MyApp(),
    ),
  );
}
// =========================================================================

// ... Giữ nguyên MainLayout vì nó không sử dụng Provider trực tiếp
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
      appBar: AppBar(
        title: const Text("English App"),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: "Từ vựng"),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), label: "Bài tập"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Tôi"),
        ],
      ),
    );
  }
}