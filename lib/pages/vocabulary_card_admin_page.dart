import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/vocabulary_card_admin_provider.dart';
import '../../widgets/flash_card/vocabulary_import_preview_sheet.dart';
import '../../widgets/flash_card/vocabulary_edit_sheet.dart';
import '../../controllers/audio_service.dart';

enum AdminMode { topic, vocabulary }

class VocabularyManagementPage extends ConsumerStatefulWidget {
  const VocabularyManagementPage({super.key});

  @override
  ConsumerState<VocabularyManagementPage> createState() =>
      _VocabularyManagementPageState();
}

class _VocabularyManagementPageState
    extends ConsumerState<VocabularyManagementPage> {
  AdminMode mode = AdminMode.vocabulary;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(vocabularyAdminProvider.notifier).loadVocabularies();
    });
  }

  void _showImportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const VocabularyImportPreviewSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vocabularyAdminProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quản lý Vocabulary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildModeSwitcher(),
          Expanded(
            child: mode == AdminMode.topic
                ? _buildTopicList(state)
                : _buildVocabularyList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _modeButton('Topic', AdminMode.topic),
          const SizedBox(width: 12),
          _modeButton('Vocabulary', AdminMode.vocabulary),
        ],
      ),
    );
  }

  Widget _modeButton(String text, AdminMode m) {
    final active = mode == m;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (mode == m) return;

          setState(() => mode = m);

          final notifier = ref.read(vocabularyAdminProvider.notifier);

          if (m == AdminMode.topic) {
            notifier.loadTopics();
          } else {
            notifier.loadVocabularies();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicList(VocabularyAdminState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.topics.isEmpty) {
      return const Center(child: Text('Chưa có topic'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('+ Thêm Topic'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.topics.length,
            itemBuilder: (_, i) {
              final t = state.topics[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    if (t.imagePath.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          t.imagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyList(VocabularyAdminState state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.vocabularies.isEmpty) {
      return const Center(child: Text('Chưa có vocabulary'));
    }

    return Column(
      children: [
        // ===== HEADER =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng: ${state.vocabularies.length} từ'),
              ElevatedButton(
                onPressed: () => _showImportModal(context),
                child: const Text('Import Excel'),
              ),
            ],
          ),
        ),

        // ===== LIST =====
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.vocabularies.length,
            itemBuilder: (context, i) {
              final v = state.vocabularies[i];

              return GestureDetector(
                onTap: () async {
                  final success = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => VocabularyEditBottomSheet(vocabulary: v),
                  );

                  if (success == true) {
                    ref
                        .read(vocabularyAdminProvider.notifier)
                        .loadVocabularies();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (v.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            v.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _tag(v.phonetic),
                                Row(
                                  children: [
                                    if (v.audioUrl.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.volume_up),
                                        onPressed: () {
                                          AudioService.play(v.audioUrl);
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              vocabularyAdminProvider.notifier,
                                            )
                                            .deleteVocabulary(v.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              v.word,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(v.meaning),
                            const SizedBox(height: 6),
                            Text(
                              'Ví dụ: ${v.example}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
