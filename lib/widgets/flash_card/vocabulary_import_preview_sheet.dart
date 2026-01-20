import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/vocabulary_card_admin_provider.dart';

class VocabularyImportPreviewSheet extends ConsumerWidget {
  const VocabularyImportPreviewSheet({super.key});

  Future<void> _pickExcel(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: kIsWeb,
    );

    if (result == null) return;

    final file = result.files.single;
    final notifier = ref.read(vocabularyAdminProvider.notifier);

    if (kIsWeb) {
      await notifier.previewImportBytes(file.bytes!, file.name);
    } else {
      await notifier.previewImport(File(file.path!));
    }
  }

  Widget _cell(
    String value,
    ValueChanged<String> onChanged, {
    double width = 140,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vocabularyAdminProvider);
    final notifier = ref.read(vocabularyAdminProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Import Vocabulary từ Excel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: state.loading ? null : () => _pickExcel(context, ref),
              icon: const Icon(Icons.upload_file),
              label: const Text('Chọn file Excel'),
            ),

            if (state.loading) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],

            if (state.previewList.isNotEmpty) ...[
              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 2,
                    horizontalMargin: 8,
                    columns: const [
                      DataColumn(label: Text('Word')),
                      DataColumn(label: Text('Meaning')),
                      DataColumn(label: Text('Phonetic')),
                      DataColumn(label: Text('Topic')),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('Audio')),
                      DataColumn(label: Text('Example')),
                      DataColumn(label: Text('Example Meaning')),
                      DataColumn(label: Text('')),
                    ],
                    rows: List.generate(state.previewList.length, (i) {
                      final v = state.previewList[i];

                      return DataRow(
                        cells: [
                          DataCell(_cell(v.word, (x) => v.word = x)),

                          DataCell(_cell(v.meaning, (x) => v.meaning = x)),

                          DataCell(_cell(v.phonetic, (x) => v.phonetic = x)),

                          DataCell(
                            _cell(
                              v.topicId.toString(),
                              (x) {
                                final parsed = int.tryParse(x);
                                if (parsed == null) return;

                                final list = [...state.previewList];
                                list[i].topicId = parsed;

                                notifier.state = state.copyWith(
                                  previewList: list,
                                );
                              },
                              width: 70,
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          DataCell(
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Row(
                                children: [
                                  if (v.imageUrl.isNotEmpty)
                                    Image.network(
                                      v.imageUrl,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: v.imageUrl,
                                      onChanged: (x) => v.imageUrl = x,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          DataCell(
                            SizedBox(
                              width: 220,
                              height: 60,
                              child: Row(
                                children: [
                                  if (v.audioUrl.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.volume_up),
                                      onPressed: () {
                                        launchUrl(Uri.parse(v.audioUrl));
                                      },
                                    ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: v.audioUrl,
                                      onChanged: (x) => v.audioUrl = x,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          DataCell(
                            _cell(v.example, (x) => v.example = x, width: 260),
                          ),

                          DataCell(
                            _cell(
                              v.exampleMeaning,
                              (x) => v.exampleMeaning = x,
                              width: 260,
                            ),
                          ),

                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                final list = [...state.previewList];
                                list.removeAt(i);
                                notifier.state = state.copyWith(
                                  previewList: list,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await notifier.confirmImport();
                    Navigator.pop(context);
                  },
                  child: const Text('Xác nhận Import'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
