import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_lesson_model.dart';
import '../models/topics_model.dart';
import '../providers/admin_lessons_provider.dart';
import '../providers/lessons_provider.dart';

class LessonManagementPage extends ConsumerStatefulWidget {
  const LessonManagementPage({super.key});

  @override
  ConsumerState<LessonManagementPage> createState() =>
      _LessonManagementPageState();
}

class _LessonManagementPageState extends ConsumerState<LessonManagementPage> {
  final _searchCtl = TextEditingController();

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _refresh() {
    ref.read(adminRefreshTickProvider.notifier).state++;
  }

  Future<void> _openCreateOrEdit({AdminLessonModel? existing}) async {
    final result = await showModalBottomSheet<AdminLessonModel>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => _LessonEditorSheet(
        topicsProvider: topicsProvider,
        existing: existing,
      ),
    );

    if (result != null) {
      final repo = ref.read(adminLessonsRepositoryProvider);
      if (existing == null) {
        await repo.createLesson(result);
      } else {
        await repo.updateLesson(existing.id, result);
      }
      if (!mounted) return;
      _refresh();
      ref.read(lessonsRefreshTickProvider.notifier).state++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existing == null ? 'Đã tạo bài học' : 'Đã cập nhật bài học'),
        ),
      );
    }
  }

  Future<void> _confirmDelete(AdminLessonModel lesson) async {
    final ok = await showDialog<bool>(
          context: context,
          useRootNavigator: true,
          barrierDismissible: true,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            actionsPadding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Xoá bài học?',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            content: Text(
              'Bạn sắp xoá "${lesson.title}".\nHành động này không thể hoàn tác.',
              style: const TextStyle(height: 1.35, color: Color(0xFF374151)),
            ),
            actions: [
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                    rootNavigator: true,
                  ).pop(false),
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    foregroundColor: const Color(0xFF111827),
                  ),
                  child: const Text('Huỷ'),
                ),
              ),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: () => Navigator.of(
                    dialogContext,
                    rootNavigator: true,
                  ).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  child: const Text('Xoá'),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    final repo = ref.read(adminLessonsRepositoryProvider);
    await repo.deleteLesson(lesson.id);

    if (!mounted) return;
    _refresh();
    ref.read(lessonsRefreshTickProvider.notifier).state++;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xoá bài học')),
    );
  }

  Future<void> _togglePremium(AdminLessonModel lesson, bool value) async {
    final repo = ref.read(adminLessonsRepositoryProvider);
    await repo.updateLesson(lesson.id, lesson.copyWith(premium: value));
    if (!mounted) return;
    _refresh();
  }

  Future<void> _showLessonActions(AdminLessonModel lesson) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (sheetContext) {
        Widget actionTile({
          required IconData icon,
          required Color color,
          required String title,
          required String subtitle,
          required VoidCallback onTap,
        }) {
          return ListTile(
            onTap: onTap,
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: Offset(0, -6),
                color: Color(0x14000000),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lesson.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Đóng',
                        onPressed: () => Navigator.of(
                          sheetContext,
                          rootNavigator: true,
                        ).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                actionTile(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF2563EB),
                  title: 'Sửa bài học',
                  subtitle: 'Chỉnh sửa tiêu đề, mô tả, level, topic...',
                  onTap: () async {
                    Navigator.of(sheetContext, rootNavigator: true).pop();
                    await _openCreateOrEdit(existing: lesson);
                  },
                ),
                actionTile(
                  icon: Icons.delete_rounded,
                  color: const Color(0xFFDC2626),
                  title: 'Xoá bài học',
                  subtitle: 'Xoá vĩnh viễn khỏi hệ thống',
                  onTap: () async {
                    Navigator.of(sheetContext, rootNavigator: true).pop();
                    await _confirmDelete(lesson);
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(
                        sheetContext,
                        rootNavigator: true,
                      ).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        foregroundColor: const Color(0xFF111827),
                      ),
                      child: const Text('Đóng'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(topicsProvider);
    final lessonsAsync = ref.watch(adminLessonsProvider);
    final selectedTopicId = ref.watch(adminTopicIdProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF111827),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Color(0xFF111827),
        ),
        title: const Text('Quản lý bài học'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            child: FilledButton.icon(
              onPressed: () => _openCreateOrEdit(),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Tạo bài học'),
              style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search
            TextField(
              controller: _searchCtl,
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, topic, level...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchCtl,
                  builder: (_, value, __) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Xoá tìm kiếm',
                      onPressed: () {
                        _searchCtl.clear();
                        ref.read(adminSearchProvider.notifier).state = '';
                      },
                    );
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => ref.read(adminSearchProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),

            // Topic filter
            topicsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('Load topics error: $e'),
              data: (topics) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      isExpanded: true,
                      value: selectedTopicId,
                      hint: const Text('Chọn topic (All nếu bỏ trống)'),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('All topics'),
                        ),
                        ...topics.map(
                          (t) => DropdownMenuItem<int?>(
                            value: t.id,
                            child: Text(t.name),
                          ),
                        ),
                      ],
                      onChanged: (v) =>
                          ref.read(adminTopicIdProvider.notifier).state = v,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            Expanded(
              child: lessonsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Load lessons error: $e')),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('Không có bài học'));
                  }

                  final lessons = [...items]
                    ..sort((a, b) => a.id.compareTo(b.id));

                  return ListView.separated(
                    itemCount: lessons.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final lesson = lessons[i];
                      final border = lesson.premium
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFE5E7EB);

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _openCreateOrEdit(existing: lesson),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border, width: 1.2),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 12,
                                offset: Offset(0, 6),
                                color: Color(0x0A000000),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  lesson.premium
                                      ? Icons.workspace_premium_rounded
                                      : Icons.menu_book_rounded,
                                  color: lesson.premium
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            lesson.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF111827),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (lesson.premium)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF7E6),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: const Color(0xFFF59E0B),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Text(
                                              'Premium',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFFB45309),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${lesson.topicName} • ${lesson.level} • ${lesson.status}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lesson.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A8A8A),
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text(
                                          'Premium',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Switch(
                                          value: lesson.premium,
                                          onChanged: (v) =>
                                              _togglePremium(lesson, v),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkResponse(
                                onTap: () => _showLessonActions(lesson),
                                radius: 24,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Color(0xFF6B7280),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
}

class _LessonEditorSheet extends ConsumerStatefulWidget {
  final ProviderListenable<AsyncValue<List<TopicModel>>> topicsProvider;
  final AdminLessonModel? existing;

  const _LessonEditorSheet({
    required this.topicsProvider,
    this.existing,
  });

  @override
  ConsumerState<_LessonEditorSheet> createState() => _LessonEditorSheetState();
}

class _LessonEditorSheetState extends ConsumerState<_LessonEditorSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtl;
  late final TextEditingController _descCtl;
  late final TextEditingController _imageCtl;
  late final TextEditingController _audioCtl;

  String _level = 'A1';
  int? _topicId;
  String _status = 'normal';
  bool _premium = false;

  bool _topicInitialized = false;
  bool _uploadingImage = false;
  bool _uploadingMedia = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtl = TextEditingController(text: e?.title ?? '');
    _descCtl = TextEditingController(text: e?.description ?? '');
    _imageCtl = TextEditingController(text: e?.imageUrl ?? '');
    _audioCtl = TextEditingController(text: e?.audioUrl ?? '');
    _level = e?.level ?? 'A1';
    _topicId = e?.topicId;
    _status = e?.status ?? 'normal';
    _premium = e?.premium ?? false;
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    _imageCtl.dispose();
    _audioCtl.dispose();
    super.dispose();
  }

  InputDecoration _dec(
    String label, {
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _pickAndUpload(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'image'
          ? ['png', 'jpg', 'jpeg', 'webp']
          : ['mp4', 'mov', 'm4a', 'mp3', 'wav'],
      withData: kIsWeb, 
    );

    if (result == null) return;
    final file = result.files.first;

    setState(() {
      if (type == 'image') _uploadingImage = true;
      if (type == 'video') _uploadingMedia = true;
    });

    try {
      final repo = ref.read(adminLessonsRepositoryProvider);
      final url = await repo.uploadFile(file: file, type: type);

      if (!mounted) return;

      setState(() {
        if (type == 'image') {
          _imageCtl.text = url;
        } else {
          _audioCtl.text = url; 
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload lỗi: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        if (type == 'image') _uploadingImage = false;
        if (type == 'video') _uploadingMedia = false;
      });
    }
  }

  void _submit({required List<TopicModel>? topics}) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final title = _titleCtl.text.trim();
    final desc = _descCtl.text.trim();

    final topicName = () {
      final t = topics?.where((x) => x.id == _topicId).toList();
      return (t != null && t.isNotEmpty)
          ? t.first.name
          : (widget.existing?.topicName ?? '');
    }();

    final model = AdminLessonModel(
      id: widget.existing?.id ?? -1,
      title: title,
      description: desc,
      level: _level,
      imageUrl: _imageCtl.text.trim().isEmpty ? null : _imageCtl.text.trim(),
      audioUrl: _audioCtl.text.trim().isEmpty ? null : _audioCtl.text.trim(),
      topicId: _topicId ?? 0,
      topicName: topicName,
      status: _status,
      premium: _premium,
    );

    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(widget.topicsProvider);
    final isEdit = widget.existing != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollCtl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: Offset(0, -6),
                color: Color(0x14000000),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Sửa bài học' : 'Tạo bài học',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEdit
                                ? 'Cập nhật thông tin và lưu thay đổi'
                                : 'Nhập thông tin để tạo bài học mới',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Đóng',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: topicsAsync.when(
                    loading: () => ListView(
                      controller: scrollCtl,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                      children: const [
                        _SectionTitle('Đang tải topics...'),
                        SizedBox(height: 12),
                        _SkeletonBox(height: 52),
                        SizedBox(height: 12),
                        _SkeletonBox(height: 90),
                        SizedBox(height: 12),
                        _SkeletonBox(height: 52),
                      ],
                    ),
                    error: (e, _) => ListView(
                      controller: scrollCtl,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                      children: [
                        const _SectionTitle('Lỗi tải dữ liệu'),
                        const SizedBox(height: 8),
                        Text('Load topics error: $e'),
                      ],
                    ),
                    data: (topics) {
                      if (!_topicInitialized) {
                        _topicInitialized = true;
                        if (_topicId == null && topics.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => _topicId = topics.first.id);
                            }
                          });
                        }
                      }

                      return ListView(
                        controller: scrollCtl,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                        children: [
                          const _SectionTitle('Thông tin chính'),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _titleCtl,
                            decoration: _dec(
                              'Tiêu đề',
                              hint: 'Ví dụ: Daily Conversation #1',
                              prefixIcon: const Icon(Icons.title_rounded),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              final s = (v ?? '').trim();
                              if (s.isEmpty) return 'Vui lòng nhập tiêu đề';
                              if (s.length < 3) return 'Tiêu đề quá ngắn';
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _descCtl,
                            decoration: _dec(
                              'Mô tả',
                              hint: 'Mô tả ngắn cho bài học',
                              prefixIcon: const Icon(Icons.notes_rounded),
                            ),
                            maxLines: 4,
                            validator: (v) {
                              final s = (v ?? '').trim();
                              if (s.isEmpty) return 'Vui lòng nhập mô tả';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _level,
                                  decoration: _dec(
                                    'Level',
                                    prefixIcon: const Icon(
                                      Icons.stacked_bar_chart_rounded,
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'A1', child: Text('A1')),
                                    DropdownMenuItem(
                                        value: 'A2', child: Text('A2')),
                                    DropdownMenuItem(
                                        value: 'B1', child: Text('B1')),
                                    DropdownMenuItem(
                                        value: 'B2', child: Text('B2')),
                                    DropdownMenuItem(
                                        value: 'C1', child: Text('C1')),
                                    DropdownMenuItem(
                                        value: 'C2', child: Text('C2')),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _level = v ?? 'A1'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _status,
                                  decoration: _dec(
                                    'Status',
                                    prefixIcon: const Icon(Icons.tune_rounded),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'normal', child: Text('normal')),
                                    DropdownMenuItem(
                                        value: 'draft', child: Text('draft')),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _status = v ?? 'normal'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          DropdownButtonFormField<int>(
                            value: _topicId,
                            decoration: _dec(
                              'Topic',
                              prefixIcon: const Icon(Icons.category_rounded),
                            ),
                            items: topics
                                .map((t) => DropdownMenuItem<int>(
                                      value: t.id,
                                      child: Text(t.name),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _topicId = v),
                            validator: (v) =>
                                (v == null) ? 'Vui lòng chọn topic' : null,
                          ),

                          const SizedBox(height: 18),
                          const _SectionTitle('Media'),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _imageCtl,
                            decoration: _dec(
                              'Image URL (tuỳ chọn)',
                              hint: 'https://...',
                              prefixIcon: const Icon(Icons.image_rounded),
                              suffixIcon: IconButton(
                                tooltip: 'Chọn ảnh từ máy',
                                onPressed: _uploadingImage
                                    ? null
                                    : () => _pickAndUpload('image'),
                                icon: _uploadingImage
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.upload_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _audioCtl,
                            decoration: _dec(
                              'Audio/Video URL (tuỳ chọn)',
                              hint: 'https://...',
                              prefixIcon:
                                  const Icon(Icons.play_circle_rounded),
                              suffixIcon: IconButton(
                                tooltip: 'Chọn video/audio từ máy',
                                onPressed: _uploadingMedia
                                    ? null
                                    : () => _pickAndUpload('video'),
                                icon: _uploadingMedia
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.upload_rounded),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                          const _SectionTitle('Quyền truy cập'),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.workspace_premium_rounded,
                                  color: Color(0xFFF59E0B),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Premium',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: _premium,
                                  onChanged: (v) =>
                                      setState(() => _premium = v),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              AnimatedPadding(
                duration: const Duration(milliseconds: 160),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                shape: const StadiumBorder(),
                                side: const BorderSide(color: Color(0xFFE5E7EB)),
                                foregroundColor: const Color(0xFF111827),
                              ),
                              child: const Text('Huỷ'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: FilledButton(
                              onPressed: () {
                                final topics = topicsAsync.asData?.value;
                                _submit(topics: topics);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                textStyle: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                              child: Text(isEdit ? 'Lưu thay đổi' : 'Tạo bài học'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: Color(0xFF111827),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  const _SkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
