import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/auth/auth_tab.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/auth/register_form.dart';
import '../../providers/auth_provider.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool isLogin = true;

  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();

  @override
  void dispose() {
    emailCtl.dispose();
    passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

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
                        AuthTab(
                          isLogin: isLogin,
                          onChange: (value) {
                            setState(() => isLogin = value);
                          },
                        ),
                        const SizedBox(height: 20),
                        isLogin
                            ? LoginForm(
                                emailCtl: emailCtl,
                                passwordCtl: passCtl,
                                isLoading: auth.isLoading,
                                error: auth.error,
                                onLogin: () {
                                  auth.login(
                                    emailCtl.text.trim(),
                                    passCtl.text.trim(),
                                  );
                                },
                                onGoogleLogin: () {
                                  auth.loginWithGoogle();
                                },
                              )
                            : RegisterForm(
                                onSuccess: () {
                                  setState(() => isLogin = true);
                                },
                              ),
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
