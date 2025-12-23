import 'package:flutter/material.dart';
import '../../widgets/auth/auth_tab.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/register_form.dart';

class AuthPage extends StatefulWidget {
  final VoidCallback onLogin;
  const AuthPage({super.key, required this.onLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double contentWidth = width > 600 ? 420 : width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFBD85D),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// TAB
                        AuthTab(
                          isLogin: isLogin,
                          onChange: (value) {
                            setState(() => isLogin = value);
                          },
                        ),

                        const SizedBox(height: 20),

                        /// FORM
                        isLogin
                            ? LoginForm(onLogin: widget.onLogin)
                            : const RegisterForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
