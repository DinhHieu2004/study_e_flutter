import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/question_admin_provider.dart';
import 'package:html/parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QuestionManagementPage extends ConsumerStatefulWidget {
  const QuestionManagementPage({super.key});

  @override
  ConsumerState<QuestionManagementPage> createState() =>
      _QuestionManagementPageState();
}

class _QuestionManagementPageState
    extends ConsumerState<QuestionManagementPage> {
  int currentPage = 1;
  PlatformFile? _selectedFile;

  Future<void> _downloadTemplate() async {
    try {
      final byteData = await rootBundle.load(
        'assets/data/pattern_questions.xlsx',
      );
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/pattern_questions.xlsx');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path)],
          text: 'File mẫu danh sách câu hỏi',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi tải file mẫu: $e")));
    }
  }

  Future<void> _importFile(BuildContext modalContext, PlatformFile file) async {
    try {
      Navigator.pop(modalContext);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đang tải lên file: ${file.name}...")),
      );

      await ref
          .read(questionAdminProvider(currentPage).notifier)
          .importQuestions(file);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Import câu hỏi thành công!"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Lỗi khi import: $e"),
        ),
      );
    }
  }


  void _showImportModal(BuildContext context) {
    _selectedFile = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Thêm câu hỏi hàng loạt",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              if (_selectedFile == null) ...[
                _buildFileActionCard(
                  title: "Tải file mẫu (Excel)",
                  subtitle: "Định dạng chuẩn của hệ thống",
                  icon: Icons.download_for_offline_rounded,
                  color: Colors.green,
                  onTap: () => _downloadTemplate(),
                ),
                const SizedBox(height: 16),
                _buildFileActionCard(
                  title: "Chọn file từ máy",
                  subtitle: "Hỗ trợ .xlsx hoặc .csv",
                  icon: Icons.upload_file_rounded,
                  color: const Color(0xFF0066FF),
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['xlsx', 'csv'],
                    );
                    if (result != null) {
                      setModalState(() {
                        _selectedFile = result.files.first;
                      });
                    }
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFile!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setModalState(() {
                            _selectedFile = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _importFile(modalContext, _selectedFile!),
                    child: const Text(
                      "Xác nhận Import ngay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setModalState(() {
                      _selectedFile = null;
                    });
                  },
                  child: const Text(
                    "Chọn file khác",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String questionId) {
  if (questionId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lỗi: ID câu hỏi rỗng!")),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (modalContext) => AlertDialog(
      title: const Text("Xác nhận xóa"),
      content: Text("Bạn có chắc chắn muốn xóa câu hỏi ID: $questionId?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(modalContext),
          child: const Text("Hủy"),
        ),
        TextButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.pop(modalContext);

            try {
              await ref
                  .read(questionAdminProvider(currentPage).notifier)
                  .deleteQuestion(questionId);

              messenger.showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Xóa thành công!"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (e) {
              messenger.showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Lỗi: ${e.toString()}"),
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          },
          child: const Text("Xóa", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}


  Widget _buildFileActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String parseHtmlString(String htmlString) {
    try {
      final document = parse(htmlString);
      return document.body?.text ?? htmlString;
    } catch (e) {
      return htmlString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(questionAdminProvider(currentPage));
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Quản lý câu hỏi",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSummaryHeader(state),
          Expanded(child: _buildQuestionList(state)),
          if (state.response != null)
            _buildPaginationBar(state.response!.totalPage),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(QuestionAdminState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Kết quả: ${state.response?.totalItems ?? 0} câu hỏi",
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () => _showImportModal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "+ Thêm mới",
                style: TextStyle(
                  color: Color(0xFF0066FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(QuestionAdminState state) {
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0066FF)),
      );
    }
    if (state.error != null) return Center(child: Text("Lỗi: ${state.error}"));

    final questions = state.response?.items ?? [];
    if (questions.isEmpty)
      return const Center(child: Text("Không có câu hỏi nào."));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag(q.difficulty, _getDifficultyColor(q.difficulty)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDelete(q.id),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                parseHtmlString(q.question),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Đáp án: ${parseHtmlString(q.correctAnswer)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaginationBar(int totalPage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pageButton(
            icon: Icons.arrow_back_ios,
            isEnabled: currentPage > 1,
            onTap: () => setState(() => currentPage--),
          ),
          Text(
            "Trang $currentPage / $totalPage",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          _pageButton(
            icon: Icons.arrow_forward_ios,
            isEnabled: currentPage < totalPage,
            onTap: () => setState(() => currentPage++),
          ),
        ],
      ),
    );
  }

  Widget _pageButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFF0066FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.grey,
          size: 16,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    final diff = difficulty.toLowerCase();
    if (diff == 'easy') return Colors.green;
    if (diff == 'medium') return Colors.orange;
    if (diff == 'hard') return Colors.red;
    return Colors.blue;
  }
}
