import 'package:flutter/material.dart';
import '../../models/vocabulary_response.dart';
import '../../controllers/audio_service.dart';
import '../../repositories/vocabulary_admin_repository.dart';

enum QuestionType { choice, fill }

class VocabularyEditBottomSheet extends StatefulWidget {
  final VocabularyResponse vocabulary;

  const VocabularyEditBottomSheet({super.key, required this.vocabulary});

  @override
  State<VocabularyEditBottomSheet> createState() =>
      _VocabularyEditBottomSheetState();
}

class _VocabularyEditBottomSheetState extends State<VocabularyEditBottomSheet> {
  // ===== Vocabulary fields =====
  late TextEditingController topicIdCtrl;
  late TextEditingController wordCtrl;
  late TextEditingController meaningCtrl;
  late TextEditingController phoneticCtrl;
  late TextEditingController exampleCtrl;
  late TextEditingController meaningECtrl;
  late TextEditingController imageUrlCtrl;
  late TextEditingController audioUrlCtrl;

  // ===== Question =====
  QuestionType questionType = QuestionType.choice;

  // Choice question
  final choiceQuestionCtrl = TextEditingController();
  final optionACtrl = TextEditingController();
  final optionBCtrl = TextEditingController();
  final optionCCtrl = TextEditingController();
  final optionDCtrl = TextEditingController();
  String correctOption = 'A';

  // Fill question
  final fillQuestionCtrl = TextEditingController();
  final fillAnswerCtrl = TextEditingController();

  final _repo = VocabularyAdminRepository();

  @override
  void initState() {
    super.initState();
    final v = widget.vocabulary;

    topicIdCtrl = TextEditingController(text: v.topicId.toString());
    wordCtrl = TextEditingController(text: v.word);
    meaningCtrl = TextEditingController(text: v.meaning);
    phoneticCtrl = TextEditingController(text: v.phonetic);
    exampleCtrl = TextEditingController(text: v.example);
    meaningECtrl = TextEditingController(text: v.exampleMeaning);
    imageUrlCtrl = TextEditingController(text: v.imageUrl);
    audioUrlCtrl = TextEditingController(text: v.audioUrl);
  }

  @override
  void dispose() {
    topicIdCtrl.dispose();
    wordCtrl.dispose();
    meaningCtrl.dispose();
    phoneticCtrl.dispose();
    exampleCtrl.dispose();
    meaningECtrl.dispose();
    imageUrlCtrl.dispose();
    audioUrlCtrl.dispose();

    choiceQuestionCtrl.dispose();
    optionACtrl.dispose();
    optionBCtrl.dispose();
    optionCCtrl.dispose();
    optionDCtrl.dispose();

    fillQuestionCtrl.dispose();
    fillAnswerCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),

                _input('Topic ID', topicIdCtrl, keyboard: TextInputType.number),
                _input('Word', wordCtrl),
                _input('Meaning', meaningCtrl),
                _input('Phonetic', phoneticCtrl),
                _input('Example', exampleCtrl),
                _input('Example Meaning', meaningECtrl),
                _input('Image URL', imageUrlCtrl),
                _input('Audio URL', audioUrlCtrl),

                if (imageUrlCtrl.text.isNotEmpty) _image(imageUrlCtrl.text),
                if (audioUrlCtrl.text.isNotEmpty) _audio(audioUrlCtrl.text),

                const SizedBox(height: 20),
                _questionTypeSwitcher(),
                const SizedBox(height: 12),

                if (questionType == QuestionType.choice) _choiceForm(),
                if (questionType == QuestionType.fill) _fillForm(),

                const SizedBox(height: 24),
                _saveButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== Widgets =====

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Chỉnh sửa Vocabulary',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: keyboard == TextInputType.multiline ? null : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _image(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 72,
          height: 72,
          color: Colors.grey.shade100,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  Widget _audio(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.volume_up),
        label: const Text('Nghe phát âm'),
        onPressed: () => AudioService.play(url),
      ),
    );
  }

  Widget _questionTypeSwitcher() {
    return Row(
      children: [
        _typeBtn('Trắc nghiệm', QuestionType.choice),
        const SizedBox(width: 12),
        _typeBtn('Điền từ', QuestionType.fill),
      ],
    );
  }

  Widget _typeBtn(String text, QuestionType type) {
    final active = questionType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => questionType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _choiceForm() {
    return Column(
      children: [
        _input(
          'Câu hỏi',
          choiceQuestionCtrl,
          keyboard: TextInputType.multiline,
        ),
        _input('Đáp án A', optionACtrl),
        _input('Đáp án B', optionBCtrl),
        _input('Đáp án C', optionCCtrl),
        _input('Đáp án D', optionDCtrl),
        DropdownButtonFormField<String>(
          value: correctOption,
          decoration: const InputDecoration(
            labelText: 'Đáp án đúng',
            border: OutlineInputBorder(),
          ),
          items: [
            'A',
            'B',
            'C',
            'D',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => correctOption = v!),
        ),
      ],
    );
  }

  Widget _fillForm() {
    return Column(
      children: [
        _input(
          'Câu hỏi (VD: I ___ an apple)',
          fillQuestionCtrl,
          keyboard: TextInputType.multiline,
        ),
        _input('Từ cần điền', fillAnswerCtrl),
      ],
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        child: const Text('Lưu thay đổi'),
      ),
    );
  }

  // ===== Submit =====

  Future<void> _submit() async {
    final payload = {
      'topicId': int.tryParse(topicIdCtrl.text),
      'word': wordCtrl.text.trim(),
      'meaning': meaningCtrl.text.trim(),
      'phonetic': phoneticCtrl.text.trim(),
      'example': exampleCtrl.text.trim(),
      'exampleMeaning': meaningECtrl.text.trim(),
      'imageUrl': imageUrlCtrl.text.trim(),
      'audioUrl': audioUrlCtrl.text.trim(),

      'questionType': questionType.name,

      'choice': questionType == QuestionType.choice
          ? {
              'question': choiceQuestionCtrl.text.trim(),
              'A': optionACtrl.text.trim(),
              'B': optionBCtrl.text.trim(),
              'C': optionCCtrl.text.trim(),
              'D': optionDCtrl.text.trim(),
              'correct': correctOption,
            }
          : null,

      'fill': questionType == QuestionType.fill
          ? {
              'question': fillQuestionCtrl.text.trim(),
              'answer': fillAnswerCtrl.text.trim(),
            }
          : null,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _repo.updateVocabulary(widget.vocabulary.id, payload);
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pop(context, true);
    } catch (_) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cập nhật thất bại')));
    }
  }
}
