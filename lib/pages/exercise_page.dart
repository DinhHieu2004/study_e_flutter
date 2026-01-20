import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quiz_provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';
import 'quiz_question_page.dart';
import 'pronunciation_page.dart';
import 'stats_page.dart';

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({super.key});

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  bool _isPronunciationMode = false;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi: ${quizState.error}")));
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

    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B9FED), Color(0xFF4A8FE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isPronunciationMode
                                  ? "Pronunciation"
                                  : "Practice Quiz",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isPronunciationMode
                                  ? "Improve your speaking skills"
                                  : "Test your knowledge with customized quizzes",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// RIGHT ICONS
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StatsScreen(),
                              ),
                            ),
                            child: _headerIcon(Icons.bar_chart),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _isPronunciationMode = true),
                            child: _headerIcon(
                              Icons.voice_chat,
                              isActive: _isPronunciationMode,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _isPronunciationMode = false),
                            child: _headerIcon(
                              Icons.assignment,
                              isActive: !_isPronunciationMode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isPronunciationMode
                    ? const PronunciationPage()
                    : _buildQuizSettings(categoriesAsync),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizSettings(AsyncValue<List<Category>> categoriesAsync) {
    return SingleChildScrollView(
      key: const ValueKey("QuizSettings"),
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quiz Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Customize your quiz experience",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildLabel("Number of Questions"),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hint: "Enter number (1-50)"),
              onChanged: (v) => amount = int.tryParse(v) ?? 10,
            ),

            const SizedBox(height: 20),

            _buildLabel("Category"),
            const SizedBox(height: 8),
            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text("Lỗi tải category"),
              data: (categories) => Container(
                width: double
                    .infinity, 
                decoration: _dropdownBoxDecoration(),
                child: DropdownButtonFormField<Category?>(
                  isExpanded: true,
                  value: selectedCategory,
                  decoration: _dropdownInputDecoration("Select category"),
                  dropdownColor: Colors.white,
                  items: [
                    const DropdownMenuItem<Category?>(
                      value: null,
                      child: Text("Trộn", overflow: TextOverflow.ellipsis),
                    ),
                    ...categories.map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedCategory = v),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel("Difficulty"),
            const SizedBox(height: 8),
            Container(
              decoration: _dropdownBoxDecoration(),
              child: DropdownButtonFormField<String>(
                value: selectedDifficulty,
                decoration: _dropdownInputDecoration("Select difficulty"),
                items: difficulties
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => selectedDifficulty = v!),
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel("Question Type"),
            const SizedBox(height: 8),
            Container(
              decoration: _dropdownBoxDecoration(),
              child: DropdownButtonFormField<String>(
                value: selectedType,
                decoration: _dropdownInputDecoration("Select question type"),
                items: types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => selectedType = v!),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9FED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : startQuiz,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "Start Quiz",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerIcon(IconData icon, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isActive ? const Color(0xFF5B9FED) : Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E3A5F),
      ),
    );
  }

  BoxDecoration _dropdownBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  InputDecoration _dropdownInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: InputBorder.none,
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5B9FED), width: 2),
      ),
    );
  }
}
