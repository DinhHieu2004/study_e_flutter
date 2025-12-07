import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';

class QuizQuestionPage extends ConsumerStatefulWidget {
  const QuizQuestionPage({super.key});

  @override
  ConsumerState<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends ConsumerState<QuizQuestionPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  String? selectedAnswer;
  int score = 0;

  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  void nextQuestion(List quizList) {
    if (selectedAnswer ==
        quizList[currentIndex].correctAnswer) {
      score++;
    }

    if (currentIndex < quizList.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });

      _controller.forward(from: 0);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(score: score, total: quizList.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState.loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizState.questions.isEmpty) {
      return Scaffold(
          body: Center(
              child: Text("Không có câu hỏi",
                  style: TextStyle(fontSize: 18))));
    }

    final current = quizState.questions[currentIndex];

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6dd5fa), Color(0xff2980b9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Progress
              Text(
                "Câu ${currentIndex + 1} / ${quizState.questions.length}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Question card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Text(
                  current.question,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 30),

              // Options
              ...current.options.map((opt) {
                bool isSelected = selectedAnswer == opt;

                Color bgColor = Colors.white;
                Color textColor = Colors.black;

                if (selectedAnswer != null) {
                  if (opt == current.correctAnswer) {
                    bgColor = Colors.green.shade400;
                    textColor = Colors.white;
                  } else if (opt == selectedAnswer) {
                    bgColor = Colors.red.shade400;
                    textColor = Colors.white;
                  }
                } else if (isSelected) {
                  bgColor = Colors.blue.shade300;
                  textColor = Colors.white;
                }

                return GestureDetector(
                  onTap: () {
                    if (selectedAnswer == null) {
                      setState(() => selectedAnswer = opt);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Text(opt,
                        style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.w500)),
                  ),
                );
              }),

              const Spacer(),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedAnswer == null
                      ? null
                      : () => nextQuestion(quizState.questions),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Tiếp theo",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int total;

  const ResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2980b9),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Hoàn thành!",
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text("Điểm của bạn:",
                  style: TextStyle(fontSize: 20)),
              Text("$score / $total",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Làm lại"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
