import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/muscle_group.dart';
import '../../data/repositories.dart';
import '../../providers.dart';

/// Lista de exercícios com busca e filtro por grupo muscular.
/// Usada na aba Exercícios (tocar edita) e como seletor no treino (tocar escolhe).
class ExerciseList extends ConsumerStatefulWidget {
  const ExerciseList({super.key, required this.onTap});

  final void Function(ExerciseInfo exercise) onTap;

  @override
  ConsumerState<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends ConsumerState<ExerciseList> {
  String _query = '';
  MuscleGroup? _group;

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exercisesProvider);
    final equipmentNames = {
      for (final e in ref.watch(equipmentProvider).value ?? const [])
        e.id: e.name,
    };
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar exercício',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final g in MuscleGroup.values)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(g.label),
                    selected: _group == g,
                    onSelected: (on) => setState(() => _group = on ? g : null),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: exercises.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Erro ao carregar exercícios: $e')),
            data: (all) {
              final filtered = [
                for (final info in all)
                  if ((_group == null ||
                          info.exercise.primaryMuscle == _group) &&
                      info.exercise.name.toLowerCase().contains(_query))
                    info,
              ];
              if (filtered.isEmpty) {
                return const Center(
                  child: Text('Nenhum exercício encontrado.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final info = filtered[i];
                  final equipment = [
                    for (final id in info.equipmentIds) ?equipmentNames[id],
                  ];
                  return ListTile(
                    title: Text(info.exercise.name),
                    subtitle: Text(
                      '${info.exercise.primaryMuscle.label} · '
                      '${equipment.isEmpty ? 'Peso corporal' : equipment.join(', ')}',
                    ),
                    onTap: () => widget.onTap(info),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Abre o seletor em tela cheia; devolve o exercício escolhido ou `null`.
Future<ExerciseInfo?> pickExercise(BuildContext context) =>
    Navigator.of(context).push(
      MaterialPageRoute<ExerciseInfo>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Adicionar exercício')),
          body: ExerciseList(onTap: (info) => Navigator.of(context).pop(info)),
        ),
      ),
    );
