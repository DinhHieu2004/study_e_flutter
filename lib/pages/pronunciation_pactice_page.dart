import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/setence_provider.dart';
import '../models/sentence_model.dart';
import '../providers/tts_service.dart';
import '../providers/speech_provider.dart';

class PronunciationPracticePage extends ConsumerWidget {
  final String level;
  final int part;

  const PronunciationPracticePage({
    super.key,
    required this.level,
    required this.part,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsService = ref.watch(ttsProvider);
    final speechState = ref.watch(speechProvider);

    final speechNotifier = ref.read(speechProvider.notifier);

    final providerKey = "${level}_$part";
    final state = ref.watch(sentenceProvider(providerKey));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.loading && state.sentences.isEmpty && state.error == null) {
        ref
            .read(sentenceProvider(providerKey).notifier)
            .fetchSentences(level, part);
      }
    });

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(body: Center(child: Text(state.error!)));
    }

    if (state.sentences.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No sentences found for this part.")),
      );
    }

    final currentSentence = state.sentences[state.currentIndex];
    final progressValue = (state.currentIndex + 1) / state.sentences.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pronunciation Practice",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Tiến độ: ${state.currentIndex + 1}/${state.sentences.length} câu (${(progressValue * 100).toStringAsFixed(1)}%)",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFFAD106),
              radius: 15,
              child: Text(
                level,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4CAF50),
              ),
              minHeight: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // CARD CHÍNH: Câu cần luyện, phiên âm, kết quả
                  _buildMainPracticeCard(currentSentence, speechState),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              ttsService.speak(currentSentence.content),
                          child: _buildControlBtn(
                            Icons.play_arrow,
                            "Listen",
                            "Native Speaker",
                            const Color(0xFF2196F3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (_) => speechNotifier.startListening(),
                          onTapUp: (_) => speechNotifier.stopListening(),
                          child: _buildControlBtn(
                            Icons.mic,
                            speechState.isListening ? "Listening..." : "Record",
                            speechState.isListening
                                ? "Release to stop"
                                : "Tap to speak",
                            speechState.isListening
                                ? Colors.green
                                : const Color(0xFFF44336),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Card tiến độ
                  _buildOverallProgressCard(state),

                  const SizedBox(height: 30),

                  //  "Try Again" ,"Next Sentence"
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF673AB7)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Try Again",
                            style: TextStyle(color: Color(0xFF673AB7)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(speechProvider.notifier).resetSpeech();
                            ref
                                .read(sentenceProvider(providerKey).notifier)
                                .nextSentence();
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF673AB7), // Màu tím
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Next Sentence",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  COMPONENT CHO TRANG PRACTICE---

  Widget _buildMainPracticeCard(
    SentenceResponse currentSentence,
    SpeechState speechState,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sentence to Practice",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              currentSentence.content,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Phonetic Transcription",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              currentSentence.phonetic ??
                  "Đang tải phiên âm...", // Hiển thị phiên âm hoặc Loading
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'monospace',
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "0%",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Chưa thực hiện",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Recording",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: speechState.isListening
                  ? Colors.green[50]
                  : Colors.orange[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: speechState.isListening
                    ? Colors.green
                    : Colors.transparent,
              ),
            ),
            child: Text(
              speechState.recognizedText.isEmpty
                  ? "Chưa ghi âm"
                  : speechState.recognizedText,
              style: TextStyle(
                color: speechState.recognizedText.isEmpty
                    ? Colors.orange
                    : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBtn(
    IconData icon,
    String title,
    String sub,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard(SentenceState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overall Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                "Total Score: 0%",
                style: TextStyle(color: Colors.green[700], fontSize: 13),
              ),
              const Spacer(),
              const Text("|", style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Text(
                "Completed: ${state.currentIndex}/${state.sentences.length}",
                style: TextStyle(color: Colors.green[700], fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

double _calculateScore(String original, String recognized) {
  if (recognized.isEmpty) return 0.0;

  String cleanOriginal = original.toLowerCase().replaceAll(
    RegExp(r'[^\w\s]'),
    '',
  );
  String cleanRecognized = recognized.toLowerCase().replaceAll(
    RegExp(r'[^\w\s]'),
    '',
  );

  List<String> originalWords = cleanOriginal.split(' ');
  List<String> recognizedWords = cleanRecognized.split(' ');

  int matches = 0;
  for (var word in originalWords) {
    if (recognizedWords.contains(word)) matches++;
  }

  return (matches / originalWords.length) * 100;
}
