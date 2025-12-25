import 'package:flutter/material.dart';

class AuthTab extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChange;

  const AuthTab({super.key, required this.isLogin, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF59E0B)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab(
            title: "Đăng nhập",
            active: isLogin,
            onTap: () => onChange(true),
          ),
          _tab(
            title: "Đăng ký",
            active: !isLogin,
            onTap: () => onChange(false),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF97316) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
        ),
      ),
    );
  }
}
