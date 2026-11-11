import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/repositories.dart';
import 'planner/planner.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(
    loadSeed: () => rootBundle.loadString('assets/seed/exercises.json'),
  );
  ref.onDispose(db.close);
  return db;
});

final catalogProvider = Provider(
  (ref) => CatalogRepository(ref.watch(dbProvider)),
);
final gymRepoProvider = Provider((ref) => GymRepository(ref.watch(dbProvider)));
final workoutRepoProvider = Provider(
  (ref) => WorkoutRepository(ref.watch(dbProvider)),
);
final metricsRepoProvider = Provider(
  (ref) => MetricsRepository(ref.watch(dbProvider)),
);

/// Inicializado em `main()` e injetado por override.
final notificationsProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('override em main()'),
);

final equipmentProvider = StreamProvider(
  (ref) => ref.watch(catalogProvider).watchEquipment(),
);
final exercisesProvider = StreamProvider(
  (ref) => ref.watch(catalogProvider).watchExercises(),
);
final gymsProvider = StreamProvider(
  (ref) => ref.watch(gymRepoProvider).watchGyms(),
);
final activeWorkoutProvider = StreamProvider(
  (ref) => ref.watch(workoutRepoProvider).watchActive(),
);
final historyProvider = StreamProvider(
  (ref) => ref.watch(workoutRepoProvider).watchHistory(),
);
final metricsProvider = StreamProvider(
  (ref) => ref.watch(metricsRepoProvider).watchAll(),
);

enum LocationSource { locating, gps, manual, unknown }

class LocationState {
  const LocationState(this.source, [this.gymId]);

  final LocationSource source;

  /// `null` = "Sem Equipamentos" (apenas peso corporal).
  final int? gymId;
}

/// Local atual: detectado por GPS no carregamento do app, com seleção manual
/// como fallback (ou para corrigir a detecção).
class LocationController extends Notifier<LocationState> {
  @override
  LocationState build() {
    Future.microtask(detect);
    return const LocationState(LocationSource.locating);
  }

  Future<void> detect() async {
    state = const LocationState(LocationSource.locating);
    final position = await currentPosition();
    final gyms = await ref.read(gymsProvider.future);
    // Uma escolha manual feita durante a busca prevalece.
    if (state.source != LocationSource.locating) return;

    GymInfo? nearest;
    var nearestDistance = double.infinity;
    if (position != null) {
      for (final info in gyms) {
        final gym = info.gym;
        if (gym.latitude == null || gym.longitude == null) continue;
        final d = distanceMeters(position, (
          lat: gym.latitude!,
          lng: gym.longitude!,
        ));
        if (d <= gym.radiusM && d < nearestDistance) {
          nearest = info;
          nearestDistance = d;
        }
      }
    }
    state = nearest == null
        ? const LocationState(LocationSource.unknown)
        : LocationState(LocationSource.gps, nearest.gym.id);
  }

  void selectManually(int? gymId) =>
      state = LocationState(LocationSource.manual, gymId);
}

final locationProvider = NotifierProvider<LocationController, LocationState>(
  LocationController.new,
);

/// Treino sugerido. Depende do catálogo, do histórico real e do local atual, então
/// é recalculado em silêncio sempre que qualquer um deles muda (treino concluído,
/// falta, troca de academia…). `null` enquanto o local ainda está sendo detectado.
final suggestionProvider = FutureProvider<Suggestion?>((ref) async {
  final location = ref.watch(locationProvider);
  if (location.source == LocationSource.locating) return null;

  final exercises = await ref.watch(exercisesProvider.future);
  final gyms = await ref.watch(gymsProvider.future);
  final recent = await ref.watch(_recentWorkoutsProvider.future);

  final available = gyms
      .where((g) => g.gym.id == location.gymId)
      .firstOrNull
      ?.equipmentIds;
  final input = PlannerInput(
    exercises: [
      for (final e in exercises)
        PlannerExercise(
          id: e.exercise.id,
          primary: e.exercise.primaryMuscle,
          secondary: e.exercise.secondaryMuscles,
          equipment: e.equipmentIds,
        ),
    ],
    history: [
      for (final workout in recent)
        for (final entry in workout.entries)
          for (final set in entry.sets)
            TrainedSet(
              primary: entry.exercise.primaryMuscle,
              secondary: entry.exercise.secondaryMuscles,
              at: set.doneAt,
            ),
    ],
    availableEquipment: available ?? const {},
    now: DateTime.now(),
  );
  return _planInIsolate(input);
});

/// Função de topo: o closure enviado ao isolate só pode capturar [input] (nunca o `ref`).
Future<Suggestion> _planInIsolate(PlannerInput input) =>
    Isolate.run(() => plan(input));

final _recentWorkoutsProvider = StreamProvider(
  (ref) => ref
      .watch(workoutRepoProvider)
      .watchSince(DateTime.now().subtract(const Duration(days: 30))),
);
