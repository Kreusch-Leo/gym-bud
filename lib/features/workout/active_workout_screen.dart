import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart'
    show CupertinoPicker, FixedExtentScrollController;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/tracking_mode.dart';
import '../../data/database.dart';
import '../../data/repositories.dart';
import '../../providers.dart';
import '../exercises/exercise_list.dart';
import 'workout_complete_screen.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Execução do treino, um passo (exercício + série) por vez, em duas fases:
/// exercício — por repetições (botão de confirmar) ou por tempo (contagem
/// regressiva) — e descanso, com a prévia do próximo passo.
///
/// Tudo que é tempo (cronômetro global, descanso e contagem do exercício) deriva de
/// horários gravados no banco, então sobrevive a segundo plano e a reinícios do app;
/// as notificações só avisam quando o app não está na tela.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late final Timer _ticker;

  /// Exercício escolhido à mão; `null` = o primeiro ainda não concluído.
  int? _selectedId;

  /// Tempo restante de uma contagem pausada; `null` = não há pausa.
  Duration? _paused;

  /// Último prazo (descanso ou contagem) já tratado: o banco leva um instante para
  /// refletir a transição, e o mesmo prazo não pode dispará-la duas vezes.
  DateTime? _handled;
  bool _completing = false;

  WorkoutRepository get _repo => ref.read(workoutRepoProvider);

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  /// Atualiza os relógios e dispara as transições por tempo: fim do descanso e fim
  /// da contagem de um exercício por tempo.
  void _tick() {
    final detail = ref.read(activeWorkoutProvider).value;
    if (detail != null) {
      final now = DateTime.now();
      bool due(DateTime? at) =>
          at != null && at != _handled && !now.isBefore(at);
      final workout = detail.workout;
      if (due(workout.restEndsAt)) {
        _handled = workout.restEndsAt;
        _endRest(detail);
      } else if (due(workout.timerEndsAt)) {
        _handled = workout.timerEndsAt;
        final current = _current(detail);
        if (current != null) _complete(detail, current);
      }
    }
    setState(() {});
  }

  WorkoutEntry? _current(WorkoutDetail detail) =>
      detail.entries.where((e) => e.link.id == _selectedId).firstOrNull ??
      detail.entries.where((e) => !e.link.done).firstOrNull ??
      detail.entries.firstOrNull;

  // --- Transições -----------------------------------------------------------

  /// Conclui a série atual: vai para o descanso ou, se era a última do treino,
  /// finaliza.
  Future<void> _complete(WorkoutDetail detail, WorkoutEntry entry) async {
    if (_completing) return;
    _completing = true;
    try {
      final restEndsAt = await _repo.completeSet(entry.link.id);
      _paused = null;
      if (restEndsAt == null) {
        await _close(savedId: await _finishAndGetId(detail.workout));
        return;
      }
      await ref.read(notificationsProvider).scheduleRestEnd(restEndsAt);
      // Exercício concluído: o próximo pendente (em ordem circular) assume a tela.
      if (mounted && entry.sets.length + 1 >= entry.link.targetSets) {
        final i = detail.entries.indexOf(entry);
        final others = [
          ...detail.entries.skip(i + 1),
          ...detail.entries.take(i),
        ];
        setState(
          () => _selectedId = others
              .where((e) => !e.link.done)
              .firstOrNull
              ?.link
              .id,
        );
      }
    } finally {
      _completing = false;
    }
  }

  /// Fim do descanso (por tempo ou por "Pular"). Exercício por tempo já sai contando.
  Future<void> _endRest(WorkoutDetail detail) async {
    await _repo.setRestEndsAt(detail.workout.id, null);
    await ref.read(notificationsProvider).cancelRestEnd();
    final link = _current(detail)?.link;
    if (link != null && link.mode == TrackingMode.time) {
      await _startTimer(detail.workout, Duration(seconds: link.targetSeconds));
    }
  }

  Future<void> _extendRest(Workout workout) async {
    final endsAt = workout.restEndsAt!.add(const Duration(seconds: 20));
    await _repo.setRestEndsAt(workout.id, endsAt);
    await ref.read(notificationsProvider).scheduleRestEnd(endsAt);
  }

  Future<void> _startTimer(Workout workout, Duration duration) {
    _paused = null;
    return _repo.setTimerEndsAt(workout.id, DateTime.now().add(duration));
  }

  Future<void> _pauseTimer(Workout workout) {
    setState(() => _paused = workout.timerEndsAt!.difference(DateTime.now()));
    return _repo.setTimerEndsAt(workout.id, null);
  }

  /// Zera a contagem (em andamento ou pausada) ao trocar de exercício ou de modo.
  Future<void> _resetTimer(Workout workout) async {
    setState(() => _paused = null);
    if (workout.timerEndsAt != null) {
      await _repo.setTimerEndsAt(workout.id, null);
    }
  }

  Future<void> _select(Workout workout, WorkoutEntry entry) {
    setState(() => _selectedId = entry.link.id);
    return _resetTimer(workout);
  }

  Future<void> _step(WorkoutDetail detail, WorkoutEntry current, int delta) {
    final entries = detail.entries;
    return _select(
      detail.workout,
      entries[(entries.indexOf(current) + delta) % entries.length],
    );
  }

  // --- Ações do treino ------------------------------------------------------

  Future<void> _selectMode(Workout workout, WorkoutEntry entry) async {
    final mode = await _showSelectModeSheet(context, entry.link.mode);
    if (mode == null || mode == entry.link.mode) return;
    await _resetTimer(workout);
    await _repo.setTargets(entry.link.id, mode: mode);
  }

  Future<void> _editRest(Workout workout) async {
    final choice = await _showRestSheet(context, workout.restCustomSec);
    if (choice == null || choice.seconds == workout.restCustomSec) return;
    await _repo.setRestCustom(workout.id, choice.seconds);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Descanso atualizado: vale a partir do próximo descanso.',
        ),
      ),
    );
  }

  Future<void> _addExercise(Workout workout) async {
    final picked = await pickExercise(context);
    if (picked != null) await _repo.addExercise(workout.id, picked.exercise.id);
  }

  Future<void> _removeExercise(WorkoutEntry entry) async {
    if (entry.sets.isNotEmpty &&
        !await _confirm(
          'Remover ${entry.exercise.name}?',
          'As ${entry.sets.length} séries registradas serão apagadas.',
          'Remover',
        )) {
      return;
    }
    await _repo.removeExercise(entry.link.id);
  }

  Future<void> _finish(WorkoutDetail detail) async {
    if (!await _confirm(
      'Finalizar treino?',
      '${detail.totalSets} séries registradas em ${detail.entries.where((e) => e.sets.isNotEmpty).length} exercícios.',
      'Finalizar',
    )) {
      return;
    }
    await _close(savedId: await _finishAndGetId(detail.workout));
  }

  /// `null` quando nada foi registrado: o treino vazio é apagado em vez de salvo.
  Future<int?> _finishAndGetId(Workout workout) async =>
      await _repo.finish(workout.id) ? workout.id : null;

  Future<void> _discard(Workout workout) async {
    if (!await _confirm(
      'Descartar treino?',
      'Nada deste treino vai para o histórico.',
      'Descartar',
    )) {
      return;
    }
    await _repo.delete(workout.id);
    await _close(savedId: null);
  }

  /// Treino salvo segue para a tela de conclusão; sem nada salvo, volta ao início.
  Future<void> _close({required int? savedId}) async {
    final notifications = ref.read(notificationsProvider);
    await notifications.cancelRestEnd();
    await notifications.cancelWorkoutRunning();
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (savedId != null) {
      await navigator.pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => WorkoutCompleteScreen(workoutId: savedId),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Treino descartado (nada salvo).')),
    );
    navigator.popUntil((route) => route.isFirst);
  }

  Future<bool> _confirm(String title, String message, String action) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action),
            ),
          ],
        ),
      ) ??
      false;

  /// Lista do treino: pular para um exercício, remover ou adicionar.
  void _showExercises() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => Consumer(
      builder: (context, ref, _) {
        final detail = ref.watch(activeWorkoutProvider).value;
        if (detail == null) return const SizedBox.shrink();
        final current = _current(detail);
        return ListView(
          shrinkWrap: true,
          children: [
            for (final entry in detail.entries)
              ListTile(
                selected: entry == current,
                leading: Icon(
                  entry.link.done
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                title: Text(entry.exercise.name),
                subtitle: Text(
                  '${entry.sets.length}/${entry.link.targetSets} séries · ${_targetLabel(entry.link)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Remover',
                  onPressed: () => _removeExercise(entry),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _select(detail.workout, entry);
                },
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Adicionar exercício'),
              onTap: () => _addExercise(detail.workout),
            ),
          ],
        );
      },
    ),
  );

  // --- Interface ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(activeWorkoutProvider).value;
    if (detail == null) {
      // Carregando, ou o treino acabou de ser finalizado e a tela está fechando.
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final workout = detail.workout;
    final now = DateTime.now();
    final current = _current(detail);
    final resting = workout.restEndsAt != null && current != null;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: resting ? scheme.primaryContainer : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: resting ? scheme.onPrimaryContainer : null,
        title: Text(
          formatDuration(now.difference(workout.startedAt)),
          style: const TextStyle(fontFeatures: _tabular),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'Exercícios',
            onPressed: _showExercises,
          ),
          PopupMenuButton<VoidCallback>(
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () => _editRest(workout),
                child: const Text('Editar descanso'),
              ),
              PopupMenuItem(
                value: () => _finish(detail),
                child: const Text('Finalizar treino'),
              ),
              PopupMenuItem(
                value: () => _discard(workout),
                child: const Text('Descartar treino'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: current == null
                ? _empty(workout)
                : resting
                ? _rest(detail, current, now)
                : _exercise(detail, current, now),
          ),
        ),
      ),
    );
  }

  Widget _empty(Workout workout) => Center(
    key: const ValueKey('empty'),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        const Text('Nenhum exercício neste treino.'),
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Adicionar exercício'),
          onPressed: () => _addExercise(workout),
        ),
      ],
    ),
  );

  Widget _exercise(WorkoutDetail detail, WorkoutEntry entry, DateTime now) {
    final theme = Theme.of(context);
    final workout = detail.workout;
    final link = entry.link;
    final timed = link.mode == TrackingMode.time;
    final running = workout.timerEndsAt != null;
    final total = Duration(seconds: link.targetSeconds);
    final remaining = workout.timerEndsAt?.difference(now) ?? _paused ?? total;
    // Metas só mudam com a contagem parada no início.
    final idle = !running && _paused == null;
    final doneSets = detail.totalSets;
    final plannedSets = detail.entries.fold(
      0,
      (sum, e) =>
          sum +
          (e.link.targetSets > e.sets.length
              ? e.link.targetSets
              : e.sets.length),
    );
    final setNumber = entry.sets.length + 1;
    final big = theme.textTheme.displayLarge?.copyWith(
      fontWeight: FontWeight.w600,
      fontFeatures: _tabular,
    );

    return Column(
      key: const ValueKey('exercise'),
      children: [
        Expanded(child: _Media(entry.exercise)),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: plannedSets == 0 ? 0 : doneSets / plannedSets,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 12),
        Text(
          entry.exercise.name,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        _Adjust(
          tooltip: 'séries',
          // Não dá para planejar menos séries do que a que está em andamento.
          onMinus: link.targetSets > setNumber
              ? () => _repo.setTargets(link.id, sets: link.targetSets - 1)
              : null,
          onPlus: () => _repo.setTargets(
            link.id,
            sets:
                (link.targetSets > setNumber ? link.targetSets : setNumber) + 1,
          ),
          child: Text(
            setNumber > link.targetSets
                ? 'Série extra ($setNumber)'
                : 'Série $setNumber de ${link.targetSets}',
          ),
        ),
        if (timed)
          _Adjust(
            tooltip: '5 segundos',
            onMinus: idle && link.targetSeconds > 5
                ? () =>
                      _repo.setTargets(link.id, seconds: link.targetSeconds - 5)
                : null,
            onPlus: idle
                ? () =>
                      _repo.setTargets(link.id, seconds: link.targetSeconds + 5)
                : null,
            child: SizedBox.square(
              dimension: 172,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: (remaining.inMilliseconds / total.inMilliseconds)
                        .clamp(0, 1),
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  Center(
                    child: Text(
                      formatDuration(_ceil(remaining)),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFeatures: _tabular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          _Adjust(
            tooltip: 'repetição',
            onMinus: link.targetReps > 1
                ? () => _repo.setTargets(link.id, reps: link.targetReps - 1)
                : null,
            onPlus: () => _repo.setTargets(link.id, reps: link.targetReps + 1),
            child: Text('×${link.targetReps}', style: big),
          ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            _Adjust(
              tooltip: '2,5 kg',
              onMinus: link.targetWeightKg > 0
                  ? () => _repo.setTargets(
                      link.id,
                      weightKg: (link.targetWeightKg - 2.5)
                          .clamp(0, double.infinity)
                          .toDouble(),
                    )
                  : null,
              onPlus: () => _repo.setTargets(
                link.id,
                weightKg: link.targetWeightKg + 2.5,
              ),
              child: Text(
                link.targetWeightKg > 0
                    ? '${formatNumber(link.targetWeightKg)} kg'
                    : 'Sem carga',
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.swap_horiz, size: 18),
              label: Text(link.mode.label),
              tooltip: 'Selecionar modo',
              onPressed: () => _selectMode(workout, entry),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          spacing: 12,
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.skip_previous),
              tooltip: 'Exercício anterior',
              onPressed: () => _step(detail, entry, -1),
            ),
            Expanded(
              child: SizedBox(
                height: 64,
                child: FilledButton(
                  onPressed: !timed
                      ? () => _complete(detail, entry)
                      : running
                      ? () => _pauseTimer(workout)
                      : () => _startTimer(workout, remaining),
                  child: Icon(
                    !timed
                        ? Icons.check
                        : running
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 36,
                    semanticLabel: !timed
                        ? 'Concluir série'
                        : running
                        ? 'Pausar'
                        : 'Iniciar',
                  ),
                ),
              ),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.skip_next),
              tooltip: 'Próximo exercício',
              onPressed: () => _step(detail, entry, 1),
            ),
          ],
        ),
      ],
    );
  }

  /// Fase de descanso: [next] já é o próximo passo (o mesmo exercício, na série
  /// seguinte, ou o próximo exercício pendente).
  Widget _rest(WorkoutDetail detail, WorkoutEntry next, DateTime now) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onPrimaryContainer;
    final workout = detail.workout;
    final link = next.link;

    return Column(
      key: const ValueKey('rest'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _Media(next.exercise)),
        const SizedBox(height: 16),
        Text(
          'PRÓXIMO ${detail.entries.indexOf(next) + 1}/${detail.entries.length}',
          style: theme.textTheme.labelLarge?.copyWith(
            color: on.withValues(alpha: 0.7),
          ),
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: Text(
                next.exercise.name,
                style: theme.textTheme.titleLarge?.copyWith(color: on),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _targetLabel(link),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: on,
                    fontFeatures: _tabular,
                  ),
                ),
                Text(
                  'Série ${next.sets.length + 1} de ${link.targetSets}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: on.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'DESCANSO',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: on,
            letterSpacing: 2,
          ),
        ),
        Text(
          formatDuration(_ceil(workout.restEndsAt!.difference(now))),
          textAlign: TextAlign.center,
          style: theme.textTheme.displayLarge?.copyWith(
            color: on,
            fontWeight: FontWeight.w600,
            fontFeatures: _tabular,
          ),
        ),
        Center(
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: on,
              backgroundColor: on.withValues(alpha: 0.12),
            ),
            icon: const Icon(Icons.tune, size: 18),
            label: Text(
              workout.restCustomSec == null
                  ? 'Editar descanso · inteligente'
                  : 'Editar descanso · ${workout.restCustomSec} s',
            ),
            onPressed: () => _editRest(workout),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    foregroundColor: on,
                    backgroundColor: on.withValues(alpha: 0.16),
                  ),
                  onPressed: () => _extendRest(workout),
                  child: const Text('+20s'),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    foregroundColor: theme.colorScheme.primaryContainer,
                    backgroundColor: on,
                  ),
                  onPressed: () => _endRest(detail),
                  child: const Text('Pular'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// `×12` ou `00:30`, conforme o modo.
String _targetLabel(WorkoutExercise link) =>
    formatTarget(link.mode, reps: link.targetReps, seconds: link.targetSeconds);

/// Arredonda para cima, para a contagem mostrar `00:30` ao iniciar e só chegar a
/// `00:00` no fim.
Duration _ceil(Duration d) =>
    Duration(seconds: (d.inMilliseconds / 1000).ceil());

/// GIF/imagem do exercício; sem mídia, um ícone.
class _Media extends StatelessWidget {
  const _Media(this.exercise);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = exercise.mediaPath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ColoredBox(
        color: scheme.surfaceContainerHigh,
        child: SizedBox.expand(
          child: path != null && File(path).existsSync()
              ? Image.file(File(path), fit: BoxFit.contain)
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      Icons.fitness_center,
                      size: 96,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Valor com botões de menos e mais; `null` desabilita o botão.
class _Adjust extends StatelessWidget {
  const _Adjust({
    required this.tooltip,
    required this.onMinus,
    required this.onPlus,
    required this.child,
  });

  /// Unidade do passo, para os rótulos de acessibilidade ("Menos 5 segundos").
  final String tooltip;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.remove),
        tooltip: 'Menos $tooltip',
        onPressed: onMinus,
      ),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Mais $tooltip',
        onPressed: onPlus,
      ),
    ],
  );
}

/// "Selecionar modo": devolve o modo confirmado, ou `null` se a folha foi fechada.
Future<TrackingMode?> _showSelectModeSheet(
  BuildContext context,
  TrackingMode current,
) {
  var selected = current;
  return showModalBottomSheet<TrackingMode>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Text(
                  'Selecionar modo',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'O exercício atual pode ser feito por repetições ou por tempo.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                for (final mode in TrackingMode.values)
                  Card.outlined(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        width: 2,
                        color: mode == selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        mode == TrackingMode.time
                            ? Icons.timer_outlined
                            : Icons.repeat,
                      ),
                      title: Text('Modo ${mode.label}'),
                      subtitle: Text(mode.description),
                      selected: mode == selected,
                      trailing: mode == selected
                          ? const Icon(Icons.check_circle)
                          : null,
                      onTap: () => setState(() => selected = mode),
                    ),
                  ),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, selected),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

final _restChoices = [for (var s = 5; s <= 300; s += 5) s];

/// "Tempo de descanso": devolve a escolha (`seconds == null` = descanso
/// inteligente), ou `null` se a folha foi fechada sem concluir.
Future<({int? seconds})?> _showRestSheet(
  BuildContext context,
  int? currentSec,
) {
  var custom = currentSec != null;
  var seconds = currentSec ?? 30;
  return showModalBottomSheet<({int? seconds})>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Text(
                  'Tempo de descanso',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: false, label: Text('Inteligente')),
                    ButtonSegment(value: true, label: Text('Personalizado')),
                  ],
                  selected: {custom},
                  onSelectionChanged: (s) => setState(() => custom = s.single),
                ),
                SizedBox(
                  height: 168,
                  child: custom
                      ? CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: _restChoices
                                .indexOf(seconds)
                                .clamp(0, _restChoices.length - 1),
                          ),
                          onSelectedItemChanged: (i) =>
                              seconds = _restChoices[i],
                          children: [
                            for (final s in _restChoices)
                              Center(
                                child: Text(
                                  '$s s',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 40,
                              color: theme.colorScheme.primary,
                            ),
                            Text(
                              'Descanso inteligente',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              'O app calcula o intervalo: mais longo com carga e ao trocar '
                              'de exercício, mais curto em exercícios por tempo.',
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, (
                      seconds: custom ? seconds : null,
                    )),
                    child: const Text('Concluir'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
