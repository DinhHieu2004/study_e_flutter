import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  int _selectedPlanIndex = 0;
  
  final List<_PremiumPlanVm> _plans = const [
    _PremiumPlanVm(
      name: 'Premium 1 tháng',
      priceText: '49.000đ / tháng',
      durationText: 'Thời hạn: 30 ngày',
      highlight: 'Phổ biến',
      approxExpiryText: 'Hết hạn dự kiến: +30 ngày',
    ),
    _PremiumPlanVm(
      name: 'Premium 1 năm',
      priceText: '399.000đ / năm',
      durationText: 'Thời hạn: 365 ngày',
      highlight: 'Tiết kiệm hơn',
      approxExpiryText: 'Hết hạn dự kiến: +365 ngày',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final plan = _plans[_selectedPlanIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Premium',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _HeaderCard(
                title: 'Mở khóa toàn bộ bài học Premium',
                subtitle:
                    'Học không giới hạn: Lessons Premium, Flashcards, Quiz (sẽ mở rộng thêm).',
              ),
              const SizedBox(height: 14),

              // Plans
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chọn gói',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: List.generate(_plans.length, (i) {
                  final p = _plans[i];
                  final selected = i == _selectedPlanIndex;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 0 ? 10 : 0, left: i == 1 ? 10 : 0),
                      child: _PlanCard(
                        name: p.name,
                        priceText: p.priceText,
                        durationText: p.durationText,
                        highlight: p.highlight,
                        selected: selected,
                        onTap: () => setState(() => _selectedPlanIndex = i),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Details
              _DetailsCard(
                title: 'Chi tiết gói đã chọn',
                rows: [
                  _kv('Giá', plan.priceText),
                  _kv('Thời hạn', plan.durationText),
                  _kv('Ngày hết hạn', plan.approxExpiryText),
                ],
              ),

              const SizedBox(height: 14),

              _DetailsCard(
                title: 'Quyền lợi Premium',
                rows: const [
                  _FeatureRow('Xem & học bài Premium'),
                  _FeatureRow('Không giới hạn vocab/flashcard từ dialog'),
                  _FeatureRow('Quiz nâng cao (sắp ra mắt)'),
                  _FeatureRow('Đồng bộ tiến độ học trên nhiều thiết bị'),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('TODO: Tích hợp thanh toán / kích hoạt Premium')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Nâng cấp Premium',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Bạn có thể hủy gia hạn bất kỳ lúc nào. Điều khoản sẽ bổ sung sau.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _kv(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(color: Color(0xFF6B6B6B))),
        Flexible(
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _PremiumPlanVm {
  final String name;
  final String priceText;
  final String durationText;
  final String highlight;
  final String approxExpiryText;

  const _PremiumPlanVm({
    required this.name,
    required this.priceText,
    required this.durationText,
    required this.highlight,
    required this.approxExpiryText,
  });
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.workspace_premium_rounded, size: 18, color: Color(0xFFB45309)),
              SizedBox(width: 6),
              Text(
                'StudyE Premium',
                style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B6B6B), height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String priceText;
  final String durationText;
  final String highlight;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.name,
    required this.priceText,
    required this.durationText,
    required this.highlight,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFF59E0B) : const Color(0xFFE6E6E6);
    final bg = selected ? const Color(0xFFFFF7E6) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                highlight,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFB45309)),
              ),
              const SizedBox(height: 6),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(priceText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(durationText, style: const TextStyle(fontSize: 11, color: Color(0xFF6B6B6B))),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;

  const _DetailsCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...rows.expand((w) => [w, const SizedBox(height: 8)]).toList()..removeLast(),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF22C55E)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, height: 1.35),
          ),
        ),
      ],
    );
  }
}
