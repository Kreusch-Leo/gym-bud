import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

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
                children: [
                  for (final w in workouts)
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
