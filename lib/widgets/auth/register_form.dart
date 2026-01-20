import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class RegisterForm extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const RegisterForm({super.key, required this.onSuccess});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  static const primary = Color(0xFFF97316);
  static const border = Color(0xFFF59E0B);
  static const darkText = Color(0xFF1F2937);

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Full Name"),
        _input(
          "Enter your full name",
          controller: _fullNameCtrl,
          icon: Icons.person,
        ),

        const SizedBox(height: 16),

        _label("Email"),
        _input("Enter your email", controller: _emailCtrl, icon: Icons.email),

        const SizedBox(height: 16),

        _label("Password"),
        _input(
          "Enter your password",
          controller: _passwordCtrl,
          obscure: true,
          icon: Icons.lock,
        ),

        const SizedBox(height: 16),

        _label("Confirm Password"),
        _input(
          "Confirm your password",
          controller: _confirmCtrl,
          obscure: true,
          icon: Icons.lock_outline,
        ),

        const SizedBox(height: 24),

        if (auth.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(auth.error!, style: const TextStyle(color: Colors.red)),
          ),

        _button(
          text: auth.isLoading ? "Signing Up..." : "Sign Up",
          onPressed: auth.isLoading ? null : _onRegister,
        ),
      ],
    );
  }

  // ===== ACTION =====
  Future<void> _onRegister() async {
    final fullName = _fullNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Invalid email");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    if (password != confirm) {
      _showError("Passwords do not match");
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .register(fullName: fullName, email: email, password: password);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register successful")));

      widget.onSuccess(); // ✅ BÁO CHA
    } else {
      final error = ref.read(authProvider).error;
      _showError(error ?? "Register failed");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== UI =====
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
    required TextEditingController controller,
    bool obscure = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
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

  Widget _button({required String text, required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
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
