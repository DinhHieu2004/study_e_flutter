import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onLogin;
  const LoginForm({super.key, required this.onLogin});

  static const primary = Color(0xFFF97316);
  static const darkText = Color(0xFF1F2937);
  static const border = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Email"),
        _input("Enter your email"),

        const SizedBox(height: 16),

        _label("Password"),
        _input("Enter your password", obscure: true),

        const SizedBox(height: 24),

        _button("Log In"),

        const SizedBox(height: 24),

        const Text(
          "OR",
          textAlign: TextAlign.center,
          style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 16),

        _googleButton(),
      ],
    );
  }

  /// LABEL
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

  /// INPUT
  Widget _input(String hint, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  /// LOGIN BUTTON
  Widget _button(String text) {
    return ElevatedButton(
      onPressed: onLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// GOOGLE BUTTON
  Widget _googleButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.g_mobiledata, size: 28, color: primary),
      label: const Text(
        "Sign in with Google",
        style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
      ),
    );
  }
}
