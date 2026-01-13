import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/statictis_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(statsProvider.notifier).loadStats());
  }

  Widget _buildStatItem(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statsProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(body: Center(child: Text("Error: ${state.error}")));
    }

    final stats = state.data;
    if (stats == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(title: const Text("Learning Statistics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 25,
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: stats.correctAnswers.toDouble(),
                              title: '', 
                              radius: 15,
                            ),
                            PieChartSectionData(
                              color: Colors.red.withOpacity(0.7),
                              value:
                                  (stats.totalQuestions - stats.correctAnswers)
                                      .toDouble(),
                              title: '',
                              radius: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Overall Performance",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatItem(
                            Colors.green,
                            "Correct",
                            stats.correctAnswers.toString(),
                          ),
                          _buildStatItem(
                            Colors.red.shade400,
                            "Wrong",
                            (stats.totalQuestions - stats.correctAnswers)
                                .toString(),
                          ),
                          const Divider(),
                          Text(
                            "Accuracy: ${stats.accuracyPercentage.toStringAsFixed(1)}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "By Category",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...stats.categoryStats.map(
              (c) => Card(
                child: ListTile(
                  title: Text(c.categoryName.replaceAll('&amp;', '&')),
                  subtitle: Text(
                    "Correct: ${c.correctAnswers}/${c.totalQuestions} - "
                    "${c.accuracy.toStringAsFixed(1)}%",
                  ),
                  trailing: SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(
                      value: c.accuracy / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        c.accuracy > 50 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Progress By Day",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ...stats.progressStats.map(
              (p) => ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(p.date),
                subtitle: Text(
                  "Correct: ${p.correctAnswers}/${p.totalQuestions}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${p.accuracy.toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
