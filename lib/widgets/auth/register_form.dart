import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  static const primary = Color(0xFFF97316);
  static const border = Color(0xFFF59E0B);
  static const darkText = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Full Name"),
        _input("Enter your full name", icon: Icons.person),

        const SizedBox(height: 16),

        _label("Email"),
        _input("Enter your email", icon: Icons.email),

        const SizedBox(height: 16),

        _label("Password"),
        _input("Enter your password", obscure: true, icon: Icons.lock),

        const SizedBox(height: 16),

        _label("Confirm Password"),
        _input(
          "Confirm your password",
          obscure: true,
          icon: Icons.lock_outline,
        ),

        const SizedBox(height: 24),

        _button("Sign Up"),
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
  Widget _input(String hint, {bool obscure = false, IconData? icon}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon != null ? Icon(icon, color: primary) : null,
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

  /// SIGN UP BUTTON
  Widget _button(String text) {
    return ElevatedButton(
      onPressed: () {},
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
}
