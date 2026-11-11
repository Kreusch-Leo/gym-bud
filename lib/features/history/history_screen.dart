import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/repositories.dart';
import '../../providers.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Domingo da semana de [d]. Por componentes de data, para não escorregar no
/// horário de verão.
DateTime _weekStart(DateTime d) =>
    DateTime(d.year, d.month, d.day - d.weekday % 7);

/// Calendário do mês, resumo por semana e os treinos concluídos.
///
/// Com [savedWorkoutId] é o último passo depois de um treino: confirma que ele foi
/// salvo e oferece "Concluir", que volta à tela inicial.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, this.savedWorkoutId});

  final int? savedWorkoutId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar histórico: $e')),
        data: (workouts) => workouts.isEmpty
            ? const Center(child: Text('Nenhum treino concluído ainda.'))
            : ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  if (workouts
                          .where((w) => w.workout.id == savedWorkoutId)
                          .firstOrNull
                      case final saved?)
                    Card(
                      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle),
                        title: const Text('Treino salvo'),
                        subtitle: Text(
                          '${formatDateTime(saved.workout.startedAt)} · '
                          '${formatDuration(saved.elapsed)} · ${saved.totalSets} séries',
                        ),
                      ),
                    ),
                  _MonthCalendar(
                    workoutDays: {
                      for (final w in workouts) _day(w.workout.startedAt),
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text(
                      'Resumo semanal',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  for (final (i, w) in workouts.indexed) ...[
                    // O histórico vem do mais novo para o mais antigo: a semana
                    // muda quando muda o domingo de referência.
                    if (i == 0 ||
                        _weekStart(workouts[i - 1].workout.startedAt) !=
                            _weekStart(w.workout.startedAt))
                      _WeekHeader(
                        start: _weekStart(w.workout.startedAt),
                        workouts: [
                          for (final other in workouts)
                            if (_weekStart(other.workout.startedAt) ==
                                _weekStart(w.workout.startedAt))
                              other,
                        ],
                        bodyWeightKg: ref.watch(latestBodyProvider).weightKg,
                      ),
                    ExpansionTile(
                      title: Text(formatDateTime(w.workout.startedAt)),
                      subtitle: Text(
                        '${w.groups.map((g) => g.label).join(', ')}\n'
                        '${formatDuration(w.workout.endedAt!.difference(w.workout.startedAt))} · '
                        '${w.totalSets} séries · ${formatNumber(w.totalLoadKg)} kg de volume',
                      ),
                      children: [
                        for (final entry in w.entries)
                          ListTile(
                            dense: true,
                            title: Text(entry.exercise.name),
                            subtitle: Text(
                              entry.sets
                                  .map(
                                    (s) => [
                                      if (s.reps != null || s.weightKg > 0)
                                        '${formatNumber(s.weightKg)} kg',
                                      if (s.reps != null) '× ${s.reps}',
                                      if (s.durationSec != null)
                                        formatDuration(
                                          Duration(seconds: s.durationSec!),
                                        ),
                                    ].join(' '),
                                  )
                                  .join('   '),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Excluir treino'),
                            onPressed: () =>
                                _confirmDelete(context, ref, w.workout.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
      ),
      bottomNavigationBar: savedWorkoutId == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.all(16),
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Concluir'),
                ),
              ),
            ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int workoutId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir treino?'),
        content: const Text(
          'O treino sai do histórico e do cálculo de equilíbrio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(workoutRepoProvider).delete(workoutId);
    }
  }
}

/// Totais de uma semana (domingo a sábado).
class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.start,
    required this.workouts,
    required this.bodyWeightKg,
  });

  final DateTime start;
  final List<WorkoutDetail> workouts;
  final double? bodyWeightKg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = workouts.fold(Duration.zero, (sum, w) => sum + w.elapsed);
    final end = DateTime(start.year, start.month, start.day + 6);
    String short(DateTime d) => '${d.day} de ${_months[d.month - 1]}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${short(start)} – ${short(end)}',
            style: theme.textTheme.titleSmall,
          ),
          Text(
            '${workouts.length} ${workouts.length == 1 ? 'treino' : 'treinos'} · '
            '${formatDuration(total)} · '
            '≈ ${formatKcal(estimateKcal(total, bodyWeightKg))}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

const _months = [
  'jan', 'fev', 'mar', 'abr', 'mai', 'jun', //
  'jul', 'ago', 'set', 'out', 'nov', 'dez',
];
const _monthNames = [
  'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', //
  'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
];

/// Mês navegável, com os dias de treino preenchidos e o dia de hoje contornado.
class _MonthCalendar extends StatefulWidget {
  const _MonthCalendar({required this.workoutDays});

  final Set<DateTime> workoutDays;

  @override
  State<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<_MonthCalendar> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = _day(DateTime.now());
    final blanks = _month.weekday % 7;
    final days = DateTime(_month.year, _month.month + 1, 0).day;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Mês anterior',
                onPressed: () => _shift(-1),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[_month.month - 1]} de ${_month.year}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Próximo mês',
                onPressed: () => _shift(1),
              ),
            ],
          ),
          Row(
            children: [
              for (final d in const ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'])
                Expanded(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
            ],
          ),
          for (var row = 0; row * 7 < blanks + days; row++)
            Row(
              children: [
                for (var cell = row * 7; cell < row * 7 + 7; cell++)
                  Expanded(
                    child: cell < blanks || cell >= blanks + days
                        ? const SizedBox(height: 40)
                        : _dayCell(
                            DateTime(
                              _month.year,
                              _month.month,
                              cell - blanks + 1,
                            ),
                            today,
                            scheme,
                          ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _dayCell(DateTime date, DateTime today, ColorScheme scheme) {
    final trained = widget.workoutDays.contains(date);
    return Semantics(
      label: trained ? 'Dia ${date.day}, com treino' : null,
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: trained ? scheme.primary : null,
          border: date == today ? Border.all(color: scheme.onSurface) : null,
        ),
        child: Text(
          '${date.day}',
          style: TextStyle(color: trained ? scheme.onPrimary : null),
        ),
      ),
    );
  }
}
