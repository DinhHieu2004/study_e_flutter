import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  final VoidCallback? onClose;

  const CoursesPage({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            const Expanded(
              child: Center(
                child: Text(
                  "Courses content here",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onClose,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.close, size: 22),
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            "Courses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
