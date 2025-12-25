import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/gemini_provider.dart';
import '../../models/quiz_question.dart';

class QuestionCard extends ConsumerWidget {
  final QuizQuestion questionData;
  final void Function(String answer)? onSelectAnswer;
  final bool showGemini;

  const QuestionCard({
    super.key,
    required this.questionData,
    this.onSelectAnswer,
    this.showGemini = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geminiState = ref.watch(geminiProvider(questionData.question));

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionData.question,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 16),

            Column(
              children: questionData.answers.map((ans) {
                final isSelected = questionData.userAnswer == ans;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                  ),
                  child: RadioListTile<String>(
                    value: ans,
                    groupValue: questionData.userAnswer,
                    onChanged: (String? val) {
                      if (val != null && onSelectAnswer != null) {
                        onSelectAnswer!(val);
                      }
                    },
                    title: Text(ans),
                  ),
                );
              }).toList(),
            ),

            if (showGemini && geminiState != null) ...[
              const SizedBox(height: 16),
              _buildGeminiButton(context, ref, geminiState),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeminiButton(
    BuildContext context,
    WidgetRef ref,
    GeminiState geminiState,
  ) {
    return GestureDetector(
      onTap: geminiState.loading
          ? null
          : () async {
           
              ref
                  .read(geminiProvider(questionData.question).notifier)
                  .fetchGemini(
                    questionData.question,
                    questionData.userAnswer ?? "Người dùng chưa chọn đáp án",
                  );

              if (!context.mounted) return;

              showDialog(
                context: context,
                builder: (ctx) => Consumer( 
                  builder: (context, ref, child) {
                    final currentState = ref.watch(geminiProvider(questionData.question));
                    
                    return AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text("Gemini Giải Thích"),
                        ],
                      ),
                      content: SingleChildScrollView( // Giúp tránh lỗi tràn màn hình khi Text quá dài
                        child: currentState.loading
                            ? const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text("Gemini đang suy nghĩ..."),
                                ],
                              )
                            : Text(
                                currentState.answer ?? "Không nhận được câu trả lời từ AI.",
                                style: const TextStyle(fontSize: 15, height: 1.5),
                              ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Đóng"),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Tham khảo từ Gemini",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (geminiState.loading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }
}