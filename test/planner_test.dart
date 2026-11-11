import 'package:flutter_test/flutter_test.dart';
import 'package:gym_bud/core/muscle_group.dart';
import 'package:gym_bud/planner/planner.dart';

const barbell = 1;
final now = DateTime(2026, 11, 10, 18);

/// Dois exercícios por grupo: um com barra (ids 0..9) e um de peso corporal (100..109).
final catalog = [
  for (final g in MuscleGroup.values) ...[
    PlannerExercise(
      id: g.index,
      primary: g,
      secondary: const [],
      equipment: const {barbell},
    ),
    PlannerExercise(
      id: 100 + g.index,
      primary: g,
      secondary: const [],
      equipment: const {},
    ),
  ],
];

List<TrainedSet> sets(MuscleGroup g, int count, Duration ago) => [
  for (var i = 0; i < count; i++)
    TrainedSet(primary: g, secondary: const [], at: now.subtract(ago)),
];

Suggestion run({
  List<PlannerExercise>? exercises,
  List<TrainedSet> history = const [],
  Set<int> equipment = const {barbell},
}) => plan(
  PlannerInput(
    exercises: exercises ?? catalog,
    history: history,
    availableEquipment: equipment,
    now: now,
  ),
);

void main() {
  test('sem histórico: sessão completa, plano ideal, no máximo 3 grupos', () {
    final s = run();
    expect(s.strategy, Strategy.ideal);
    expect(s.exerciseIds, hasLength(5));
    expect(s.exerciseIds.toSet(), hasLength(5));
    expect(s.groups.length, lessThanOrEqualTo(maxGroupsPerSession));
    expect(s.deficit.values, everyElement(1.0));
  });

  test('filtro de viabilidade: sem equipamento, só peso corporal', () {
    final s = run(equipment: const {});
    expect(s.exerciseIds, isNotEmpty);
    expect(s.exerciseIds, everyElement(greaterThanOrEqualTo(100)));
  });

  test('grupo fatigado fica fora mesmo estando atrasado', () {
    // 5 séries há 1 h: fadiga acima do limite, volume ainda abaixo da meta.
    final s = run(
      history: sets(MuscleGroup.peito, 5, const Duration(hours: 1)),
    );
    expect(s.fatigue[MuscleGroup.peito], greaterThanOrEqualTo(fatigueLimit));
    expect(s.deficit[MuscleGroup.peito], greaterThan(0));
    expect(s.groups, isNot(contains(MuscleGroup.peito)));
  });

  test('objetivo de equilíbrio: o grupo atrasado entra na sugestão', () {
    // Tudo treinado há 4 dias (já descansado), menos costas.
    final history = [
      for (final g in MuscleGroup.values)
        if (g != MuscleGroup.costas)
          ...sets(g, g.weeklyTargetSets * 2, const Duration(days: 4)),
    ];
    final s = run(history: history);
    expect(s.groups, contains(MuscleGroup.costas));
    expect(s.deficit[MuscleGroup.costas], 1.0);
  });

  test('efeito do treino real: o que foi feito muda a próxima sugestão', () {
    final before = run();
    final trained = before.groups.first;
    final after = run(history: sets(trained, 6, const Duration(hours: 2)));
    expect(after.groups, isNot(contains(trained)));
  });

  test(
    'adaptação: mantém os grupos e substitui exercícios quando há alternativa',
    () {
      // Só costas está atrasado; sem a barra, a alternativa de peso corporal resolve.
      final history = [
        for (final g in MuscleGroup.values)
          if (g != MuscleGroup.costas)
            ...sets(g, g.weeklyTargetSets * 2, const Duration(days: 4)),
      ];
      final onlyBarbellFirst = [
        for (final e in catalog)
          // Costas tem 2 exercícios com barra (ideal) e 2 de peso corporal (substitutos).
          if (e.primary != MuscleGroup.costas) e,
        const PlannerExercise(
          id: 200,
          primary: MuscleGroup.costas,
          secondary: [],
          equipment: {barbell},
        ),
        const PlannerExercise(
          id: 201,
          primary: MuscleGroup.costas,
          secondary: [],
          equipment: {barbell},
        ),
        const PlannerExercise(
          id: 300,
          primary: MuscleGroup.costas,
          secondary: [],
          equipment: {},
        ),
        const PlannerExercise(
          id: 301,
          primary: MuscleGroup.costas,
          secondary: [],
          equipment: {},
        ),
      ];
      final ideal = run(exercises: onlyBarbellFirst, history: history);
      expect(ideal.exerciseIds, containsAll([200, 201]));

      final s = run(
        exercises: onlyBarbellFirst,
        history: history,
        equipment: const {},
      );
      expect(s.strategy, Strategy.substituteExercises);
      expect(s.exerciseIds, containsAll([300, 301]));
      expect(s.exerciseIds, everyElement(greaterThanOrEqualTo(100)));
    },
  );

  test(
    'adaptação: troca os grupos do dia quando o local não atende os ideais',
    () {
      // Peito, costas e quadríceps estão zerados e só têm exercícios com barra;
      // os demais grupos estão quase em dia e só têm peso corporal.
      const lagging = {
        MuscleGroup.peito,
        MuscleGroup.costas,
        MuscleGroup.quadriceps,
      };
      final exercises = [
        for (final g in MuscleGroup.values)
          if (lagging.contains(g)) ...[
            PlannerExercise(
              id: g.index,
              primary: g,
              secondary: const [],
              equipment: const {barbell},
            ),
            PlannerExercise(
              id: 50 + g.index,
              primary: g,
              secondary: const [],
              equipment: const {barbell},
            ),
          ] else
            PlannerExercise(
              id: 100 + g.index,
              primary: g,
              secondary: const [],
              equipment: const {},
            ),
      ];
      final history = [
        for (final g in MuscleGroup.values)
          if (!lagging.contains(g))
            ...sets(g, g.weeklyTargetSets, const Duration(days: 4)),
      ];
      final ideal = run(exercises: exercises, history: history);
      expect(ideal.strategy, Strategy.ideal);
      expect(ideal.groups.toSet(), lagging);

      final s = run(
        exercises: exercises,
        history: history,
        equipment: const {},
      );
      expect(s.strategy, Strategy.switchGroups);
      expect(s.idealGroups.toSet(), lagging);
      expect(s.groups, isNotEmpty);
      expect(s.groups.toSet().intersection(lagging), isEmpty);
      expect(s.exerciseIds, everyElement(greaterThanOrEqualTo(100)));
    },
  );

  test('nada viável: estratégia none e lista vazia', () {
    final s = run(
      exercises: [
        for (final e in catalog)
          if (e.equipment.isNotEmpty) e,
      ],
      equipment: const {},
    );
    expect(s.strategy, Strategy.none);
    expect(s.exerciseIds, isEmpty);
  });
}
