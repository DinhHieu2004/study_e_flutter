import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quiz_provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
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

  String selectedDifficulty = "easy";
  String selectedType = "multiple";
  Category? selectedCategory;

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
    difficulty: selectedDifficulty,
    type: selectedType,
    categoryId: selectedCategory?.id ?? 0,
  );

  if (!mounted) return; 

  setState(() => isLoading = false);

  final quizState = ref.read(quizProvider);
  if (quizState.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi: ${quizState.error}")),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const QuizQuestionPage()),
  );
}

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);

    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Quiz Options",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Amount
            Text("Số câu hỏi", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            TextField(
              keyboardType: TextInputType.number,
              decoration: inputDecor(hint: "VD: 10"),
              onChanged: (v) => amount = int.tryParse(v) ?? 10,
            ),

            const SizedBox(height: 20),

            // Category (API)
            Text("Danh mục", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),

            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text("Lỗi tải category"),
              data: (categories) {
                return DropdownButtonFormField<Category?>(
                  initialValue: selectedCategory,
                  decoration: inputDecor(),
                  items: [
                    const DropdownMenuItem<Category?>(
                      value: null,
                      child: Text("Trộn"),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem<Category?>(
                        value: c,
                        child: Text(c.name),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedCategory = v),
                );  
              },
            ),

            const SizedBox(height: 20),

            // Difficulty
            Text("Độ khó", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedDifficulty,
              decoration: inputDecor(),
              items: difficulties
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => selectedDifficulty = v!),
            ),

            const SizedBox(height: 20),

            // Type
            Text("Loại câu hỏi", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: inputDecor(),
              items: types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => selectedType = v!),
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
                        style:
                            TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecor({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
