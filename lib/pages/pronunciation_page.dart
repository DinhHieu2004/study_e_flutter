import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Đảm bảo import đúng đường dẫn đến file Provider bạn vừa viết
import '../providers/pronunciation_provider.dart';
import 'pronunciation_pactice_page.dart';

class PronunciationPage extends ConsumerStatefulWidget {
  final VoidCallback? onBackToQuiz;

  const PronunciationPage({super.key, this.onBackToQuiz});

  @override
  ConsumerState<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends ConsumerState<PronunciationPage> {
  // Biến lưu level đang chọn. Nếu null hiện màn hình chọn Level.
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      // Nếu chưa chọn Level thì hiện Level Selection, chọn rồi thì hiện Part Selection
      child: _selectedLevel == null
          ? _buildLevelSelection(context)
          : _buildPartSelection(context, _selectedLevel!),
    );
  }

  // --- MÀN HÌNH 1: CHỌN LEVEL ---
  Widget _buildLevelSelection(BuildContext context) {
    return Column(
      key: const ValueKey(
        "LevelScreen",
      ), // Cần Key để AnimatedSwitcher hoạt động
      children: [
        const SizedBox(height: 10),
        _buildSectionContainer(
          title: "Select Pronunciation Level",
          subtitle: "Practice pronunciation with sentences and audio samples",
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLevelCard(
                      context,
                      "A1",
                      "Beginner",
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLevelCard(
                      context,
                      "A2",
                      "Elementary",
                      const Color(0xFF2196F3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildLevelCard(
                      context,
                      "B1",
                      "Intermediate",
                      const Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLevelCard(
                      context,
                      "B2",
                      "Upper-Intermediate",
                      const Color(0xFFFF5722),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildFeaturesSection(),
      ],
    );
  }

  // --- MÀN HÌNH 2: CHỌN PART (Gọi API qua Provider) ---
  Widget _buildPartSelection(BuildContext context, String level) {
    // Lắng nghe state từ provider của bạn
    final state = ref.watch(partPronunciationProvider(level));

    // Tự động gọi API fetch dữ liệu lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.parts == null && !state.loading && state.error == null) {
        ref
            .read(partPronunciationProvider(level).notifier)
            .fetchPartPronunciation(level);
      }
    });

    return Column(
      key: const ValueKey("PartScreen"),
      children: [
        // Nút Back quay lại màn hình chọn Level
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _selectedLevel = null),
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            label: Text("Back to $level Levels"),
          ),
        ),
        _buildSectionContainer(
          title: "Select a Part",
          subtitle: "Choose a part to start practicing pronunciation",
          child: _buildStateContent(state),
        ),
      ],
    );
  }

  // Hàm xử lý nội dung dựa trên trạng thái API (Loading/Error/Success)
  Widget _buildStateContent(PartPronunciationState state) {
    if (state.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    final parts = state.parts ?? [];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final partNum = parts[index];
        return _buildPartCard(partNum);
      },
    );
  }

  // --- CÁC COMPONENT GIAO DIỆN NHỎ ---

  Widget _buildSectionContainer({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildPartCard(String partNum) {
    return GestureDetector(
      onTap: () {
        // Chuyển sang trang luyện tập chi tiết
        print("Go to Level $_selectedLevel - Part $partNum");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PronunciationPracticePage(
              level: _selectedLevel!,
              part: int.parse(partNum),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4), 
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Part $partNum",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Practice pronunciation with sentences in part $partNum",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.blue.shade400, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String level,
    String title,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: Container(
        height: 120, // Thu gọn lại một chút cho đẹp
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              level,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return _buildSectionContainer(
      title: "Features",
      subtitle: "Tools to help you improve",
      child: Column(
        children: [
          _buildFeatureItem(Icons.mic, "Record and compare", Colors.blue),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.play_arrow,
            "Native speaker samples",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
