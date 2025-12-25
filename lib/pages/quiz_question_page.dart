import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '/../widgets/exerises/gemini_widget.dart';
import 'quiz_question_result_page.dart';

class QuizQuestionPage extends ConsumerStatefulWidget {
  const QuizQuestionPage({super.key});

  @override
  ConsumerState<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends ConsumerState<QuizQuestionPage> {
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quizState.error != null) {
      return Scaffold(body: Center(child: Text("Lỗi: ${quizState.error}")));
    }

    if (quizState.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("Không có câu hỏi")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("English Quiz")),
      body: Column(
        children: [
          LinearProgressIndicator(
            value:
                quizState.questions.where((q) => q.userAnswer != null).length /
                quizState.questions.length,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quizState.questions.length,
              itemBuilder: (context, index) {
                final q = quizState.questions[index];
                return QuestionCard(
                  questionData: q,
                  onSelectAnswer: (answer) {
                    ref.read(quizProvider.notifier).selectAnswer(index, answer);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _stopwatch.stop();
                  await ref
                      .read(quizProvider.notifier)
                      .submitQuiz(_stopwatch.elapsed.inSeconds);

                  if (!mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultPage()),
                  );
                },
                child: const Text("Nộp bài"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


