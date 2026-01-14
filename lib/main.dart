import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/courses_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/exercise_page.dart';
import 'pages/profile_page.dart';
import '../../widgets/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "English App",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066FF)),
        useMaterial3: false,
      ),
      // home: AuthGate(),
      home: MainLayout(),
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

  final GlobalKey<NavigatorState> _shellNavKey = GlobalKey<NavigatorState>();
  bool _isSubPage = false;

  void _setTab(int index) {
    setState(() => _currentIndex = index);

    _shellNavKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => _buildPage(index)),
      (route) => false,
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return CoursesPage(onClose: () => _setTab(0));
      case 2:
        return const SearchPage();
      case 3:
        return const ExercisePage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dimAllTabs = _isSubPage;

    return Scaffold(
      body: Navigator(
        key: _shellNavKey,
        observers: [
          _ShellObserver(
            onStackChanged: (canPop) {
              if (!mounted) return;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                if (_isSubPage == canPop) return;
                setState(() => _isSubPage = canPop);
              });
            },
          ),
        ],
        onGenerateRoute: (_) {
          return MaterialPageRoute(builder: (_) => _buildPage(_currentIndex));
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: dimAllTabs ? Colors.grey : Colors.black,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            elevation: 0,

            onTap: _setTab,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: Icon(dimAllTabs ? Icons.home_outlined : Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.menu_book_outlined),
                activeIcon: Icon(
                  dimAllTabs ? Icons.menu_book_outlined : Icons.menu_book,
                ),
                label: "Topics",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.article_outlined),
                activeIcon: Icon(
                  dimAllTabs ? Icons.article_outlined : Icons.article,
                ),
                label: "Exercise",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: Icon(
                  dimAllTabs ? Icons.person_outline : Icons.person,
                ),
                label: "Me",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShellObserver extends NavigatorObserver {
  final void Function(bool canPop) onStackChanged;
  _ShellObserver({required this.onStackChanged});

  void _notify(NavigatorState? nav) {
    if (nav == null) return;
    onStackChanged(nav.canPop());
  }

  @override
  void didPush(Route route, Route? previousRoute) => _notify(navigator);

  @override
  void didPop(Route route, Route? previousRoute) => _notify(navigator);

  @override
  void didRemove(Route route, Route? previousRoute) => _notify(navigator);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _notify(navigator);
}
