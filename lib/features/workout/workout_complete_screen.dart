import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/effort.dart';
import '../../core/format.dart';
import '../../data/database.dart';
import '../../data/repositories.dart';
import '../../providers.dart';
import '../history/history_screen.dart';

/// Conclusão do treino: celebração, resumo da sessão, percepção de esforço e peso
/// atual, com a régua de IMC acompanhando o que é digitado.
class WorkoutCompleteScreen extends ConsumerStatefulWidget {
  const WorkoutCompleteScreen({super.key, required this.workoutId});

  final int workoutId;

  @override
  ConsumerState<WorkoutCompleteScreen> createState() =>
      _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends ConsumerState<WorkoutCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final _confetti = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..forward();
  final _weight = TextEditingController();
  final _height = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Parte das últimas medidas conhecidas; quem já começou a digitar não é atropelado.
    ref.read(metricsProvider.future).then((_) {
      if (!mounted) return;
      final latest = ref.read(latestBodyProvider);
      if (_weight.text.isEmpty && latest.weightKg != null) {
        _weight.text = formatNumber(latest.weightKg!);
      }
      if (_height.text.isEmpty && latest.heightCm != null) {
        _height.text = formatNumber(latest.heightCm!);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  /// `null` para vazio ou inválido.
  static double? _parse(String text) {
    final value = double.tryParse(text.trim().replaceAll(',', '.'));
    return value != null && value > 0 ? value : null;
  }

  /// Grava a medição se o peso foi informado e algo mudou, e segue para o histórico.
  Future<void> _next() async {
    final weight = _parse(_weight.text), height = _parse(_height.text);
    final invalid =
        (weight == null && _weight.text.trim().isNotEmpty) ||
        (height == null && _height.text.trim().isNotEmpty);
    if (invalid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use apenas números maiores que zero.')),
      );
      return;
    }
    final latest = ref.read(latestBodyProvider);
    if (weight != null &&
        (weight != latest.weightKg || height != latest.heightCm)) {
      await ref
          .read(metricsRepoProvider)
          .add(
            BodyMetricsCompanion.insert(
              date: DateTime.now(),
              weightKg: Value(weight),
              heightCm: Value(height),
            ),
          );
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HistoryScreen(savedWorkoutId: widget.workoutId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = ref
        .watch(historyProvider)
        .value
        ?.where((w) => w.workout.id == widget.workoutId)
        .firstOrNull;
    if (detail == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final weight = _parse(_weight.text);
    final bodyBmi = bmi(weight, _parse(_height.text));
    final kcal = estimateKcal(
      detail.elapsed,
      weight ?? ref.watch(latestBodyProvider).weightKg,
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Boa! Treino concluído!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        _Stat('Exercícios', '${detail.entries.length}'),
                        _Stat('Calorias (est.)', formatKcal(kcal)),
                        _Stat('Tempo', formatDuration(detail.elapsed)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Como foi o treino?', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final (effort, icon) in const [
                      (Effort.hard, Icons.sentiment_very_dissatisfied),
                      (Effort.right, Icons.sentiment_satisfied),
                      (Effort.easy, Icons.sentiment_very_satisfied),
                    ])
                      Expanded(
                        child: _EffortChoice(
                          effort: effort,
                          icon: icon,
                          selected: detail.workout.effort == effort,
                          // Tocar de novo na escolha atual desfaz a resposta.
                          onTap: () => ref
                              .read(workoutRepoProvider)
                              .setEffort(
                                widget.workoutId,
                                detail.workout.effort == effort ? null : effort,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Seu peso agora', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _measureField(_weight, 'Peso (kg)')),
                    const SizedBox(width: 12),
                    Expanded(child: _measureField(_height, 'Altura (cm)')),
                  ],
                ),
                const SizedBox(height: 20),
                BmiRuler(bmi: bodyBmi),
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ConfettiPainter(_confetti)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: FilledButton(onPressed: _next, child: const Text('Próximo')),
        ),
      ),
    );
  }

  Widget _measureField(TextEditingController controller, String label) =>
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          FittedBox(child: Text(value, style: theme.textTheme.titleLarge)),
        ],
      ),
    );
  }
}

class _EffortChoice extends StatelessWidget {
  const _EffortChoice({
    required this.effort,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final Effort effort;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? scheme.primaryContainer : null,
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 4),
              Text(effort.label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

/// Régua de IMC de 15 a 40, com as faixas da OMS e um marcador no valor atual.
class BmiRuler extends StatelessWidget {
  const BmiRuler({super.key, required this.bmi});

  final double? bmi;

  static const _min = 15.0, _max = 40.0;

  /// Fim de cada faixa e a sua cor.
  static const _bands = [
    (16.0, Color(0xFF5C6BC0)),
    (18.5, Color(0xFF42A5F5)),
    (25.0, Color(0xFF66BB6A)),
    (30.0, Color(0xFFFFCA28)),
    (35.0, Color(0xFFFFA726)),
    (40.0, Color(0xFFEF5350)),
  ];
  static const _ticks = [15.0, 18.5, 25.0, 30.0, 35.0, 40.0];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = bmi;
    if (value == null) {
      return Text(
        'Informe peso e altura para ver seu IMC.',
        style: theme.textTheme.bodyMedium,
      );
    }
    final fraction = ((value - _min) / (_max - _min)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IMC ${value.toStringAsFixed(1)} · ${bmiCategory(value)}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment(fraction * 2 - 1, 0),
          child: Icon(
            Icons.arrow_drop_down,
            size: 28,
            color: theme.colorScheme.onSurface,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                for (final (i, (end, color)) in _bands.indexed)
                  Expanded(
                    // Largura proporcional à faixa (em décimos de IMC).
                    flex: ((end - (i == 0 ? _min : _bands[i - 1].$1)) * 10)
                        .round(),
                    child: ColoredBox(
                      color: color,
                      child: const SizedBox.expand(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 16,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              clipBehavior: Clip.none,
              children: [
                for (final tick in _ticks)
                  Positioned(
                    left:
                        constraints.maxWidth * (tick - _min) / (_max - _min) -
                        20,
                    width: 40,
                    child: Text(
                      formatNumber(tick),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Confetes caindo uma vez. As peças saem de uma semente fixa: cada quadro só
/// depende do progresso da animação.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress) : super(repaint: progress);

  final Animation<double> progress;

  static const _colors = [
    Color(0xFFEF5350),
    Color(0xFFFFCA28),
    Color(0xFF66BB6A),
    Color(0xFF42A5F5),
    Color(0xFFAB47BC),
  ];
  static final _pieces = () {
    final random = Random(7);
    return [
      for (var i = 0; i < 90; i++)
        (
          x: random.nextDouble(),
          delay: random.nextDouble() * 0.4,
          speed: 0.9 + random.nextDouble() * 0.8,
          sway: random.nextDouble() * 2 * pi,
          size: 6 + random.nextDouble() * 6,
          color: _colors[i % _colors.length],
        ),
    ];
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t >= 1) return;
    final paint = Paint();
    for (final p in _pieces) {
      final fall = (t - p.delay) * p.speed;
      if (fall < 0) continue;
      final y = fall * 1.6 * size.height - p.size;
      if (y > size.height) continue;
      final x = p.x * size.width + sin(p.sway + fall * 12) * 14;
      paint.color = p.color.withValues(alpha: (1 - t).clamp(0.0, 1.0));
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p.sway + fall * 10)
        ..drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => false;
}
