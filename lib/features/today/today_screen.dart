import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/muscle_group.dart';
import '../../data/backup.dart';
import '../../data/repositories.dart';
import '../../planner/planner.dart';
import '../../providers.dart';
import '../workout/workout_overview_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeWorkoutProvider).value;
    final suggestion = ref.watch(suggestionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoje'),
        actions: [
          PopupMenuButton<bool>(
            tooltip: 'Backup',
            onSelected: (export) =>
                export ? _export(context, ref) : _import(context, ref),
            itemBuilder: (_) => const [
              PopupMenuItem(value: true, child: Text('Exportar backup (JSON)')),
              PopupMenuItem(value: false, child: Text('Importar JSON')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        children: [
          const _LocationCard(),
          if (active != null)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Treino em andamento'),
                subtitle: Text(
                  'Iniciado às ${formatDateTime(active.workout.startedAt)} · '
                  '${active.totalSets} séries',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openOverview(context),
              ),
            ),
          suggestion.when(
            loading: () => const _Loading('Calculando o treino sugerido…'),
            error: (e, _) => Card(
              child: ListTile(
                title: Text('Não foi possível calcular a sugestão: $e'),
              ),
            ),
            data: (s) => s == null
                ? const _Loading('Detectando onde você está…')
                : _SuggestionCard(suggestion: s, canStart: active == null),
          ),
          if (active == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Treino livre'),
                onPressed: () => startWorkout(context, ref, const []),
              ),
            ),
          if (suggestion.value case final s?) _BalanceCard(suggestion: s),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final json = await exportBackup(ref.read(dbProvider));
      final saved = await FilePicker.saveFile(
        fileName: 'gym-bud-backup.json',
        bytes: utf8.encode(json),
      );
      if (saved != null) {
        messenger.showSnackBar(const SnackBar(content: Text('Backup salvo.')));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Falha ao exportar: $e')));
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
      );
      final path = picked.firstOrNull?.path;
      if (path == null) return;
      final result = await importBackup(
        ref.read(dbProvider),
        await File(path).readAsString(),
      );
      messenger.showSnackBar(SnackBar(content: Text('Importado: $result.')));
    } on FormatException catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Arquivo inválido: ${e.message}')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Falha ao importar: $e')));
    }
  }
}

/// Visão geral do treino em andamento ou, sem um, do plano em [exerciseIds].
void _openOverview(BuildContext context, [List<int> exerciseIds = const []]) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutOverviewScreen(exerciseIds: exerciseIds),
      ),
    );

class _Loading extends StatelessWidget {
  const _Loading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      title: Text(text),
    ),
  );
}

class _LocationCard extends ConsumerWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final gyms = ref.watch(gymsProvider).value ?? const <GymInfo>[];
    final gymName = gyms
        .where((g) => g.gym.id == location.gymId)
        .firstOrNull
        ?.gym
        .name;
    final (icon, title, subtitle) = switch (location.source) {
      LocationSource.locating => (
        Icons.gps_not_fixed,
        'Localizando…',
        'Buscando sinal de GPS',
      ),
      LocationSource.gps => (
        Icons.gps_fixed,
        gymName ?? 'Local',
        'Detectado por GPS',
      ),
      LocationSource.manual => (
        Icons.place,
        gymName ?? 'Sem equipamentos',
        gymName == null
            ? 'Só peso corporal · escolhido por você'
            : 'Escolhido por você',
      ),
      LocationSource.unknown => (
        Icons.location_off,
        'Local desconhecido',
        'Sugestão só com peso corporal. Toque para escolher a academia.',
      ),
    };
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.swap_horiz),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (sheet) {
            final controller = ref.read(locationProvider.notifier);
            void choose(void Function() action) {
              action();
              Navigator.pop(sheet);
            }

            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final info in gyms)
                    ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(info.gym.name),
                      subtitle: Text(
                        '${info.equipmentIds.length} equipamentos',
                      ),
                      onTap: () =>
                          choose(() => controller.selectManually(info.gym.id)),
                    ),
                  ListTile(
                    leading: const Icon(Icons.accessibility_new),
                    title: const Text('Sem equipamentos'),
                    subtitle: const Text('Apenas exercícios de peso corporal'),
                    onTap: () => choose(() => controller.selectManually(null)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.my_location),
                    title: const Text('Detectar por GPS'),
                    onTap: () => choose(controller.detect),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SuggestionCard extends ConsumerWidget {
  const _SuggestionCard({required this.suggestion, required this.canStart});

  final Suggestion suggestion;
  final bool canStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final byId = {
      for (final e
          in ref.watch(exercisesProvider).value ?? const <ExerciseInfo>[])
        e.exercise.id: e.exercise,
    };
    String names(List<MuscleGroup> groups) =>
        groups.map((g) => g.label).join(', ');
    final explanation = switch (suggestion.strategy) {
      Strategy.ideal =>
        'Estes são os grupos mais atrasados e descansados para hoje.',
      Strategy.substituteExercises =>
        'Faltam equipamentos aqui para o plano ideal: os grupos do dia foram mantidos e os '
            'exercícios incompatíveis, substituídos.',
      Strategy.switchGroups =>
        'O ideal para hoje seria ${names(suggestion.idealGroups)}, mas não há equipamento '
            'suficiente aqui. Trocar os grupos do dia preserva melhor o equilíbrio.',
      Strategy.none =>
        'Nenhum exercício viável agora: os grupos estão fatigados ou não há exercícios '
            'compatíveis com este local. Descanse ou escolha outro local.',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Treino sugerido', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final g in suggestion.groups) Chip(label: Text(g.label)),
              ],
            ),
            const SizedBox(height: 8),
            Text(explanation, style: theme.textTheme.bodySmall),
            for (final (i, id) in suggestion.exerciseIds.indexed)
              if (byId[id] case final exercise?)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
                  title: Text(exercise.name),
                  subtitle: Text(exercise.primaryMuscle.label),
                ),
            if (canStart && suggestion.exerciseIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('Ver treino sugerido'),
                    onPressed: () =>
                        _openOverview(context, suggestion.exerciseIds),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.suggestion});

  final Suggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Equilíbrio de volume', style: theme.textTheme.titleMedium),
            Text(
              'Meta semanal por grupo · 🔥 = ainda fatigado',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final g in MuscleGroup.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(width: 104, child: Text(g.label)),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 1 - (suggestion.deficit[g] ?? 1),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        (suggestion.fatigue[g] ?? 0) >= fatigueLimit
                            ? '🔥'
                            : '',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
