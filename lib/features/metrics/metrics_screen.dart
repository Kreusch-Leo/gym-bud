import 'package:drift/drift.dart' show Value;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/database.dart';
import '../../data/repositories.dart';
import '../../providers.dart';

/// Uma medição com a altura "em vigor" na data (a última informada até ali),
/// para que o IMC tenha histórico mesmo quando a altura não é redigitada.
typedef _Point = ({BodyMetric metric, double? heightCm});

typedef _Series = ({String label, String unit, double? Function(_Point) value});

final List<_Series> _series = [
  (label: 'Peso', unit: 'kg', value: (p) => p.metric.weightKg),
  (label: 'IMC', unit: '', value: (p) => bmi(p.metric.weightKg, p.heightCm)),
  (label: '% Gordura', unit: '%', value: (p) => p.metric.bodyFatPct),
  (label: 'Peito', unit: 'cm', value: (p) => p.metric.chestCm),
  (label: 'Cintura', unit: 'cm', value: (p) => p.metric.waistCm),
  (label: 'Quadril', unit: 'cm', value: (p) => p.metric.hipCm),
  (label: 'Braço', unit: 'cm', value: (p) => p.metric.armCm),
  (label: 'Coxa', unit: 'cm', value: (p) => p.metric.thighCm),
];

class MetricsScreen extends ConsumerStatefulWidget {
  const MetricsScreen({super.key});

  @override
  ConsumerState<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends ConsumerState<MetricsScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(metricsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Evolução corporal')),
      body: metrics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar medições: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text('Registre sua primeira medição no botão +.'),
            );
          }
          double? height;
          final points = <_Point>[
            for (final m in list)
              (metric: m, heightCm: height = m.heightCm ?? height),
          ];
          final latestBmi = points.reversed
              .map(_series[1].value)
              .nonNulls
              .firstOrNull;
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              if (latestBmi != null)
                ListTile(
                  leading: const Icon(Icons.monitor_weight),
                  title: Text('IMC ${latestBmi.toStringAsFixed(1)}'),
                  subtitle: Text(bmiCategory(latestBmi)),
                ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    for (final (i, s) in _series.indexed)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(s.label),
                          selected: _selected == i,
                          onSelected: (_) => setState(() => _selected = i),
                        ),
                      ),
                  ],
                ),
              ),
              _Chart(points: points, series: _series[_selected]),
              const Divider(),
              for (final p in points.reversed)
                ListTile(
                  dense: true,
                  title: Text(formatDate(p.metric.date)),
                  subtitle: Text(
                    [
                      for (final s in _series)
                        if (s.value(p) case final v?)
                          '${s.label} ${v.toStringAsFixed(1)}${s.unit}',
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir medição',
                    onPressed: () =>
                        ref.read(metricsRepoProvider).delete(p.metric.id),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova medição',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MetricFormScreen(
              lastHeightCm: metrics.value?.reversed
                  .map((m) => m.heightCm)
                  .nonNulls
                  .firstOrNull,
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.points, required this.series});

  final List<_Point> points;
  final _Series series;

  @override
  Widget build(BuildContext context) {
    final first = points.first.metric.date;
    final spots = [
      for (final p in points)
        if (series.value(p) case final v?)
          FlSpot(p.metric.date.difference(first).inMinutes / 1440, v),
    ];
    if (spots.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(child: Text('Sem dados de ${series.label} ainda.')),
      );
    }
    final color = Theme.of(context).colorScheme.primary;
    const hidden = AxisTitles(sideTitles: SideTitles(showTitles: false));
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 24, 8),
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            // Um ponto só não define escala: abre uma margem em volta dele.
            minY: spots.length == 1 ? spots.first.y - 1 : null,
            maxY: spots.length == 1 ? spots.first.y + 1 : null,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                color: color,
                barWidth: 3,
                isCurved: false,
              ),
            ],
            titlesData: FlTitlesData(
              topTitles: hidden,
              rightTitles: hidden,
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 44),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  // Só as pontas, para as datas não se sobreporem.
                  getTitlesWidget: (value, meta) =>
                      value == meta.min || value == meta.max
                      ? SideTitleWidget(
                          meta: meta,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                          child: Text(
                            formatDate(
                              first.add(
                                Duration(minutes: (value * 1440).round()),
                              ),
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            gridData: const FlGridData(drawVerticalLine: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}

class MetricFormScreen extends ConsumerStatefulWidget {
  const MetricFormScreen({super.key, this.lastHeightCm});

  final double? lastHeightCm;

  @override
  ConsumerState<MetricFormScreen> createState() => _MetricFormScreenState();
}

class _MetricFormScreenState extends ConsumerState<MetricFormScreen> {
  static const _fields = [
    'Peso (kg)',
    'Altura (cm)',
    '% de gordura',
    'Peito (cm)',
    'Cintura (cm)',
    'Quadril (cm)',
    'Braço (cm)',
    'Coxa (cm)',
  ];
  late final _controllers = [
    for (final (i, _) in _fields.indexed)
      TextEditingController(
        text: i == 1 && widget.lastHeightCm != null
            ? formatNumber(widget.lastHeightCm!)
            : null,
      ),
  ];
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final values = <double?>[];
    for (final c in _controllers) {
      final text = c.text.trim().replaceAll(',', '.');
      final value = text.isEmpty ? null : double.tryParse(text);
      if (text.isNotEmpty && (value == null || value <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Use apenas números maiores que zero.')),
        );
        return;
      }
      values.add(value);
    }
    // A altura sozinha (pré-preenchida) não conta como medição.
    if ([
      for (final (i, v) in values.indexed)
        if (i != 1) v,
    ].nonNulls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha ao menos uma medida.')),
      );
      return;
    }
    await ref
        .read(metricsRepoProvider)
        .add(
          BodyMetricsCompanion.insert(
            date: _date,
            weightKg: Value(values[0]),
            heightCm: Value(values[1]),
            bodyFatPct: Value(values[2]),
            chestCm: Value(values[3]),
            waistCm: Value(values[4]),
            hipCm: Value(values[5]),
            armCm: Value(values[6]),
            thighCm: Value(values[7]),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova medição')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.event),
            label: Text(formatDate(_date)),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          for (final (i, label) in _fields.indexed)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: _controllers[i],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text('Salvar'),
        onPressed: _save,
      ),
    );
  }
}
