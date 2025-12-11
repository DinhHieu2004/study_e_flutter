import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quiz_provider.dart';
import 'quiz_question_page.dart';

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  final List<String> difficulties = ["easy", "medium", "hard"];
  final List<String> types = ["multiple", "boolean"];

  String? selectedDifficulty = "easy";
  String? selectedType = "multiple";
  int amount = 10;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startQuiz() async {
    final quizNotifier = ref.read(quizProvider.notifier);

    setState(() => isLoading = true);

    await quizNotifier.fetchQuestions(
      amount: amount,
      difficulty: selectedDifficulty!,
      type: selectedType!,
    );

    setState(() => isLoading = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizQuestionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider); // dùng nếu muốn hiển thị loading trong tương lai

    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Quiz Options",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Amount input
            Text("Số câu hỏi", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),

            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: "VD: 10",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = int.tryParse(value) ?? 10;
              },
            ),

            const SizedBox(height: 20),

            // Difficulty
            Text("Độ khó", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),

            DropdownButtonFormField<String>(
              value: selectedDifficulty,
              decoration: inputDecor(),
              items: difficulties.map((d) {
                return DropdownMenuItem(value: d, child: Text(d));
              }).toList(),
              onChanged: (v) => setState(() => selectedDifficulty = v),
            ),

            const SizedBox(height: 20),

            // Type
            Text("Loại câu hỏi", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),

            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: inputDecor(),
              items: types.map((t) {
                return DropdownMenuItem(value: t, child: Text(t));
              }).toList(),
              onChanged: (v) => setState(() => selectedType = v),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : startQuiz,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        "Start Quiz",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecor() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
