import 'package:flutter/material.dart';
import '../../pages/auth_page.dart';
import '../../main.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isLoggedIn = false;

  void onLogin() {
    setState(() => isLoggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return AuthPage(onLogin: onLogin);
    }
    return const MainLayout();
  }
}
