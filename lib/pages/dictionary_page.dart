import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../providers/dictionary_provider.dart';
import '../utils/app_colors.dart';

class DictionaryPage extends ConsumerStatefulWidget {
  final String word;
  const DictionaryPage({super.key, required this.word});

  @override
  ConsumerState<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends ConsumerState<DictionaryPage> {
  late TextEditingController _controller;
  late String currentWord;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentWord = widget.word;
    _controller = TextEditingController(text: currentWord);

    Future.microtask(() {
      ref.read(dictionaryProvider.notifier).searchWord(currentWord);
    });
  }

  void _search() {
    final word = _controller.text.trim();
    if (word.isEmpty) return;

    setState(() => currentWord = word);
    ref.read(dictionaryProvider.notifier).searchWord(word);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dictionaryProvider);
    final width = MediaQuery.of(context).size.width;
    final double contentWidth = width > 700 ? 600 : width;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: const Text(
          "Dictionary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔍 SEARCH BAR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _search(),
                        decoration: const InputDecoration(
                          hintText: "Search dictionary...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 📘 RESULT
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.error != null)
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      )
                    else if (state.current != null)
                      _buildResult(state)
                    else
                      const Text("No results"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(state) {
    final allPhonetics = state.current!.phonetics;

    // 🔥 CHỈ LẤY PHONETIC CÓ AUDIO
    final phoneticsWithAudio = allPhonetics
        .where((p) => p.audio != null && p.audio!.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔤 WORD
        Text(
          currentWord,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        // 🔊 PHONETICS (CHỈ CÁI CÓ AUDIO)
        if (phoneticsWithAudio.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: phoneticsWithAudio.map<Widget>((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // IPA TEXT
                    Expanded(
                      child: Text(
                        p.text ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    // AUDIO BUTTON
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      color: Colors.blueAccent,
                      onPressed: () {
                        _audioPlayer.play(UrlSource(p.audio!));
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 20),

        // 📚 MEANINGS
        ...state.current!.meanings.map<Widget>((meaning) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PART OF SPEECH
                  Text(
                    meaning.partOfSpeech ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DEFINITIONS
                  ...meaning.definitions.map<Widget>((def) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ${def.definition ?? ""}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          if (def.vietnameseDefinition != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 14),
                              child: Text(
                                def.vietnameseDefinition!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
