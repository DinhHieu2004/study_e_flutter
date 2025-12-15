import 'package:flutter/material.dart';

enum LessonItemStatus { normal, activePrimary, activeSecondary, completed, locked }

class LessonListPage extends StatefulWidget {
  final String courseTitle;
  final String courseSubtitle; 
  final VoidCallback? onClose;

  const LessonListPage({
    super.key,
    required this.courseTitle,
    this.courseSubtitle = "",
    this.onClose,
  });

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  late final List<_LessonData> _lessons = [
    const _LessonData(
      order: 1,
      title: "Greetings",
      description: "Hello / Hi / Good morning + basic responses",
      meta: "5 min",
      status: LessonItemStatus.activePrimary,
    ),
    const _LessonData(
      order: 2,
      title: "Introduce yourself",
      description: "Name, country, job, simple sentences",
      meta: "7 min",
      status: LessonItemStatus.locked,
    ),
    const _LessonData(
      order: 3,
      title: "Numbers",
      description: "1–100, phone numbers, prices",
      meta: "6 min",
      status: LessonItemStatus.locked,
    ),
    const _LessonData(
      order: 4,
      title: "Daily routines",
      description: "I wake up, I go to work, I have lunch…",
      meta: "8 min",
      status: LessonItemStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 10),
            _buildCourseHeader(),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _lessons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final l = _lessons[i];
                  return LessonListItem(
                    order: l.order,
                    title: l.title,
                    description: l.description,
                    meta: l.meta,
                    status: l.status,
                    onTap: () {
                      debugPrint("Open lesson ${l.order}: ${l.title}");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onClose ?? () => Navigator.pop(context),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Lessons",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC), 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu_book, color: Color(0xFF2F6BFF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.courseTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                if (widget.courseSubtitle.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.courseSubtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LessonListItem extends StatelessWidget {
  final int order;
  final String title;
  final String description;
  final String meta; 
  final IconData actionIcon;
  final VoidCallback? onTap;
  final LessonItemStatus status;

  const LessonListItem({
    super.key,
    required this.order,
    required this.title,
    required this.description,
    required this.meta,
    this.actionIcon = Icons.chevron_right,
    this.onTap,
    this.status = LessonItemStatus.normal,
  });

  @override
  Widget build(BuildContext context) {
    const textGrey = Color(0xFF8A8A8A);

    final bool isLocked = status == LessonItemStatus.locked;
    final VoidCallback? effectiveTap = isLocked ? null : onTap;

    final (
      Color borderColor,
      Color actionBgColor,
      Color actionIconColor,
      Color orderBgColor,
      Color orderTextColor,
      IconData effectiveActionIcon,
    ) = switch (status) {
      LessonItemStatus.activePrimary => (
          const Color(0xFF2F6BFF),
          const Color(0xFF2F6BFF),
          Colors.white,
          const Color(0xFFEEF4FF),
          const Color(0xFF2F6BFF),
          actionIcon,
        ),
      LessonItemStatus.activeSecondary => (
          const Color(0xFFFF8A00),
          const Color(0xFFFF8A00),
          Colors.white,
          const Color(0xFFFFF3E6),
          const Color(0xFFFF8A00),
          actionIcon,
        ),
      LessonItemStatus.completed => (
          const Color(0xFF23B26D),
          const Color(0xFF23B26D),
          Colors.white,
          const Color(0xFFEAF8F0),
          const Color(0xFF23B26D),
          Icons.check,
        ),
      LessonItemStatus.locked => (
          const Color(0xFFE6E6E6),
          const Color(0xFFF2F3F5),
          const Color(0xFF9AA0A6),
          const Color(0xFFF2F3F5),
          const Color(0xFF9AA0A6),
          Icons.lock,
        ),
      LessonItemStatus.normal => (
          const Color(0xFFE6E6E6),
          const Color(0xFFF2F3F5),
          Colors.black87,
          const Color(0xFFF2F3F5),
          Colors.black87,
          actionIcon,
        ),
    };

    return Opacity(
      opacity: isLocked ? 0.7 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: orderBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: orderTextColor,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: effectiveTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: actionBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(effectiveActionIcon, size: 22, color: actionIconColor),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonData {
  final int order;
  final String title;
  final String description;
  final String meta;
  final LessonItemStatus status;

  const _LessonData({
    required this.order,
    required this.title,
    required this.description,
    required this.meta,
    required this.status,
  });
}
