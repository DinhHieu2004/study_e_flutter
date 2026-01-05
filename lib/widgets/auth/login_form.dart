import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final TextEditingController emailCtl;
  final TextEditingController passwordCtl;
  final bool isLoading;
  final String? error;

  const LoginForm({
    super.key,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.emailCtl,
    required this.passwordCtl,
    required this.isLoading,
    required this.error,
  });

  static const primary = Color(0xFFF97316);
  static const darkText = Color(0xFF1F2937);
  static const border = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Email"),
        _input("Enter your email", controller: emailCtl),

        const SizedBox(height: 16),

        _label("Password"),
        _input("Enter your password", obscure: true, controller: passwordCtl),

        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: isLoading ? null : onLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Log In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),

        if (error != null) ...[
          const SizedBox(height: 12),
          Text(error!, style: const TextStyle(color: Colors.red)),
        ],

        const SizedBox(height: 24),

        OutlinedButton.icon(
          onPressed: isLoading ? null : onGoogleLogin,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            side: const BorderSide(color: border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.g_mobiledata, size: 28, color: primary),
          label: const Text(
            "Sign in with Google",
            style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        color: darkText,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _input(
    String hint, {
    bool obscure = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
