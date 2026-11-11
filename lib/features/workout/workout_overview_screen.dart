import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/repositories.dart';
import '../../providers.dart';
import 'active_workout_screen.dart';

/// Inicia (ou retoma) o treino no local atual e abre a tela de Treino Ativo.
Future<void> startWorkout(
  BuildContext context,
  WidgetRef ref,
  List<int> exerciseIds,
) async {
  final notifications = ref.read(notificationsProvider);
  final repo = ref.read(workoutRepoProvider);
  await repo.start(
    gymId: ref.read(locationProvider).gymId,
    exerciseIds: exerciseIds,
  );
  await notifications.requestPermissions();
  await notifications.showWorkoutRunning(DateTime.now());
  if (context.mounted) _openActive(context);
}

void _openActive(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const ActiveWorkoutScreen()));

typedef _Item = ({String name, String muscle, String target, bool done});

/// Visão geral antes da execução: tempo estimado, quantidade de exercícios e a
/// rotina. Mostra o treino em andamento, se houver ("Reiniciar" / "Continuar");
/// senão, o plano em [exerciseIds], ainda não iniciado ("Iniciar").
class WorkoutOverviewScreen extends ConsumerWidget {
  const WorkoutOverviewScreen({super.key, this.exerciseIds = const []});

  final List<int> exerciseIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final active = ref.watch(activeWorkoutProvider).value;
    final List<_Item> items;
    final Duration estimate;
    if (active != null) {
      items = [
        for (final e in active.entries)
          (
            name: e.exercise.name,
            muscle: e.exercise.primaryMuscle.label,
            target:
                '${e.sets.length}/${e.link.targetSets} · '
                '${formatTarget(e.link.mode, reps: e.link.targetReps, seconds: e.link.targetSeconds)}',
            done: e.link.done,
          ),
      ];
      estimate = active.estimatedRemaining;
    } else {
      final byId = {
        for (final e
            in ref.watch(exercisesProvider).value ?? const <ExerciseInfo>[])
          e.exercise.id: e.exercise,
      };
      final plan = exerciseIds.map((id) => byId[id]).nonNulls.toList();
      // Ainda sem metas: vale o padrão com que cada exercício entra no treino.
      items = [
        for (final e in plan)
          (
            name: e.name,
            muscle: e.primaryMuscle.label,
            target:
                '$defaultTargetSets × '
                '${formatTarget(e.trackingMode, reps: 12, seconds: 30)}',
            done: false,
          ),
      ];
      estimate = plan.fold(
        Duration.zero,
        (total, e) =>
            total + estimateSets(sets: defaultTargetSets, mode: e.trackingMode),
      );
    }
    final minutes = (estimate.inSeconds / 60).ceil();
    final count = items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(active != null ? 'Treino em andamento' : 'Treino sugerido'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              '≈ $minutes min${active != null ? ' restantes' : ''} · '
              '$count ${count == 1 ? 'exercício' : 'exercícios'}',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Nenhum exercício ainda. Eles podem ser adicionados durante o treino.',
              ),
            ),
          for (final (i, item) in items.indexed)
            ListTile(
              leading: CircleAvatar(
                child: item.done ? const Icon(Icons.check) : Text('${i + 1}'),
              ),
              title: Text(item.name),
              subtitle: Text(item.muscle),
              trailing: Text(item.target, style: theme.textTheme.titleMedium),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: active == null
              ? FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                  onPressed: () => startWorkout(context, ref, exerciseIds),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _restart(context, ref, active),
                        child: const Text('Reiniciar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _openActive(context),
                        child: Text('Continuar · ${_percent(active)}%'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  int _percent(WorkoutDetail detail) => detail.targetSets == 0
      ? 0
      : (100 * detail.totalSets / detail.targetSets).round().clamp(0, 100);

  /// Volta o treino ao começo; só pede confirmação se há séries a perder.
  Future<void> _restart(
    BuildContext context,
    WidgetRef ref,
    WorkoutDetail detail,
  ) async {
    if (detail.totalSets > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reiniciar treino?'),
          content: Text(
            'As ${detail.totalSets} séries registradas serão apagadas e o tempo volta a zero.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    final notifications = ref.read(notificationsProvider);
    await ref.read(workoutRepoProvider).restart(detail.workout.id);
    await notifications.cancelRestEnd();
    await notifications.showWorkoutRunning(DateTime.now());
    if (context.mounted) _openActive(context);
  }
}
