/// Planejador de treino no estilo STRIPS — Dart puro, sem Flutter, para rodar em Isolate.
///
/// - **Estado**: volume semanal e fadiga por grupo muscular + o plano parcial da sessão.
/// - **Ações**: exercícios. Pré-condições: equipamento disponível, grupo recuperado,
///   exercício ainda não usado, limite de grupos por sessão. Efeitos: somam volume e fadiga.
/// - **Objetivo**: todos os grupos na meta semanal; a distância ao objetivo é a soma dos
///   déficits ao quadrado, e a busca (beam search) minimiza essa distância.
///
/// O estado inicial é sempre derivado do histórico real, então faltas e desvios são
/// absorvidos sozinhos a cada novo cálculo — não existe um "plano salvo" para corrigir.
library;

import 'dart:math';

import '../core/muscle_group.dart';

const double secondaryWeight = 0.5;

/// Acima disto (em séries efetivas recentes) o grupo é considerado não recuperado.
const double fatigueLimit = 4;
const double fatigueHalfLifeHours = 24;
const int maxGroupsPerSession = 3;
const int _beamWidth = 12;

/// Custo de trocar um grupo muscular do dia: só vale trocar se o ganho de equilíbrio
/// superar isto. Para referência, um exercício de 3 séries num grupo zerado reduz a
/// distância em ~0,5.
const double switchPenaltyPerGroup = 0.05;

class PlannerExercise {
  const PlannerExercise({
    required this.id,
    required this.primary,
    required this.secondary,
    required this.equipment,
  });

  final int id;
  final MuscleGroup primary;
  final List<MuscleGroup> secondary;

  /// Lista estrita de equipamentos necessários (ids). Vazia = peso corporal.
  final Set<int> equipment;
}

/// Uma série realmente executada.
class TrainedSet {
  const TrainedSet({
    required this.primary,
    required this.secondary,
    required this.at,
  });

  final MuscleGroup primary;
  final List<MuscleGroup> secondary;
  final DateTime at;
}

class PlannerInput {
  const PlannerInput({
    required this.exercises,
    required this.history,
    required this.availableEquipment,
    required this.now,
    this.sessionExercises = 5,
    this.setsPerExercise = 3,
  });

  final List<PlannerExercise> exercises;

  /// Séries dos últimos 30 dias (mais antigas são ignoradas).
  final List<TrainedSet> history;
  final Set<int> availableEquipment;
  final DateTime now;
  final int sessionExercises;
  final int setsPerExercise;
}

enum Strategy {
  /// O plano ideal é viável no local atual.
  ideal,

  /// Grupos do dia mantidos; exercícios incompatíveis substituídos.
  substituteExercises,

  /// Grupos do dia trocados para preservar o equilíbrio semanal/mensal.
  switchGroups,

  /// Nenhum exercício viável (sem equipamento compatível ou tudo fatigado).
  none,
}

class Suggestion {
  const Suggestion({
    required this.exerciseIds,
    required this.groups,
    required this.idealGroups,
    required this.strategy,
    required this.deficit,
    required this.fatigue,
  });

  final List<int> exerciseIds;
  final List<MuscleGroup> groups;

  /// Grupos que seriam treinados sem restrição de equipamento.
  final List<MuscleGroup> idealGroups;
  final Strategy strategy;

  /// Déficit atual por grupo, de 0 (na meta) a 1 (nada feito).
  final Map<MuscleGroup, double> deficit;
  final Map<MuscleGroup, double> fatigue;
}

class PlanState {
  PlanState(this.volume, this.fatigue, this.plan);

  /// Estado inicial: fadiga e balanço de volume dos últimos 7 a 30 dias.
  factory PlanState.fromHistory(List<TrainedSet> history, DateTime now) {
    final week = {for (final g in MuscleGroup.values) g: 0.0};
    final month = {for (final g in MuscleGroup.values) g: 0.0};
    final fatigue = {for (final g in MuscleGroup.values) g: 0.0};
    for (final set in history) {
      final hours = now.difference(set.at).inMinutes / 60;
      if (hours < 0 || hours > 30 * 24) continue;
      final decay = pow(0.5, hours / fatigueHalfLifeHours).toDouble();
      void add(MuscleGroup g, double w) {
        month[g] = month[g]! + w;
        if (hours <= 7 * 24) week[g] = week[g]! + w;
        fatigue[g] = fatigue[g]! + w * decay;
      }

      add(set.primary, 1);
      for (final g in set.secondary) {
        add(g, secondaryWeight);
      }
    }
    // A semana corrente pesa mais; a média mensal corrige desequilíbrios antigos.
    final volume = {
      for (final g in MuscleGroup.values)
        g: 0.7 * week[g]! + 0.3 * month[g]! * 7 / 30,
    };
    return PlanState(volume, fatigue, const []);
  }

  final Map<MuscleGroup, double> volume;
  final Map<MuscleGroup, double> fatigue;
  final List<PlannerExercise> plan;

  Set<MuscleGroup> get groups => {for (final e in plan) e.primary};

  double deficitOf(MuscleGroup g) =>
      (max(0.0, g.weeklyTargetSets - volume[g]!) / g.weeklyTargetSets)
          .toDouble();

  /// Distância ao objetivo (0 = volume equilibrado em todos os grupos).
  double get goalDistance {
    var sum = 0.0;
    for (final g in MuscleGroup.values) {
      final d = deficitOf(g);
      sum += d * d;
    }
    return sum;
  }

  bool canApply(PlannerExercise e) {
    if (fatigue[e.primary]! >= fatigueLimit) return false;
    if (plan.any((p) => p.id == e.id)) return false;
    final current = groups;
    return current.contains(e.primary) || current.length < maxGroupsPerSession;
  }

  PlanState apply(PlannerExercise e, int sets) {
    final v = Map.of(volume);
    final f = Map.of(fatigue);
    void add(MuscleGroup g, double w) {
      v[g] = v[g]! + w;
      f[g] = f[g]! + w;
    }

    add(e.primary, sets.toDouble());
    for (final g in e.secondary) {
      add(g, sets * secondaryWeight);
    }
    return PlanState(v, f, [...plan, e]);
  }
}

PlanState _search(
  PlanState initial,
  List<PlannerExercise> actions,
  PlannerInput input,
) {
  var beam = [initial];
  for (var depth = 0; depth < input.sessionExercises; depth++) {
    // Planos com os mesmos exercícios em outra ordem são o mesmo estado.
    final next = <String, PlanState>{};
    for (final state in beam) {
      for (final action in actions) {
        if (!state.canApply(action)) continue;
        final child = state.apply(action, input.setsPerExercise);
        final key = (child.plan.map((e) => e.id).toList()..sort()).join(',');
        next.putIfAbsent(key, () => child);
      }
    }
    if (next.isEmpty) break;
    final ranked = next.entries.toList()
      ..sort((a, b) {
        final byDistance = a.value.goalDistance.compareTo(b.value.goalDistance);
        return byDistance != 0 ? byDistance : a.key.compareTo(b.key);
      });
    beam = [for (final e in ranked.take(_beamWidth)) e.value];
  }
  return beam.first;
}

Suggestion plan(PlannerInput input) {
  final initial = PlanState.fromHistory(input.history, input.now);

  // Filtro de viabilidade: elimina ações cuja pré-condição de equipamento falha.
  final feasible = [
    for (final e in input.exercises)
      if (input.availableEquipment.containsAll(e.equipment)) e,
  ];

  final ideal = _search(initial, input.exercises, input);
  final idealGroups = ideal.groups;

  PlanState chosen;
  Strategy strategy;
  if (ideal.plan.every(feasible.contains)) {
    chosen = ideal;
    strategy = ideal.plan.isEmpty ? Strategy.none : Strategy.ideal;
  } else {
    // Adaptação dinâmica: manter os grupos do dia trocando exercícios, ou trocar os grupos.
    final keep = _search(initial, [
      for (final e in feasible)
        if (idealGroups.contains(e.primary)) e,
    ], input);
    final swap = _search(initial, feasible, input);
    final changedGroups = swap.groups.difference(idealGroups).length;
    final swapCost = swap.goalDistance + switchPenaltyPerGroup * changedGroups;
    if (keep.plan.isNotEmpty && keep.goalDistance <= swapCost) {
      chosen = keep;
      strategy = Strategy.substituteExercises;
    } else {
      chosen = swap;
      strategy = swap.plan.isEmpty ? Strategy.none : Strategy.switchGroups;
    }
  }

  // Agrupa os exercícios por grupo muscular, na ordem em que os grupos entraram no plano.
  final groups = chosen.groups.toList();
  final ordered = [
    for (final g in groups)
      for (final e in chosen.plan)
        if (e.primary == g) e.id,
  ];

  return Suggestion(
    exerciseIds: ordered,
    groups: groups,
    idealGroups: idealGroups.toList(),
    strategy: strategy,
    deficit: {for (final g in MuscleGroup.values) g: initial.deficitOf(g)},
    fatigue: initial.fatigue,
  );
}
