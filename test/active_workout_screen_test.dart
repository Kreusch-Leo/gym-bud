import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_bud/core/muscle_group.dart';
import 'package:gym_bud/core/tracking_mode.dart';
import 'package:gym_bud/data/database.dart';
import 'package:gym_bud/data/repositories.dart';
import 'package:gym_bud/features/workout/active_workout_screen.dart';
import 'package:gym_bud/providers.dart';
import 'package:gym_bud/services/notification_service.dart';

void main() {
  testWidgets('execução → descanso → próxima série, em tela pequena', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = AppDatabase(executor: NativeDatabase.memory());
    final repo = WorkoutRepository(db);
    // O banco responde fora do relógio falso do teste; as animações, dentro dele.
    Future<void> settle() async {
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    await tester.runAsync(() async {
      final catalog = CatalogRepository(db);
      final other = await catalog.saveExercise(
        name: 'Supino',
        primary: MuscleGroup.peito,
        secondary: [],
        equipmentIds: {},
      );
      final plank = await catalog.saveExercise(
        name: 'Prancha',
        primary: MuscleGroup.peito,
        secondary: [],
        equipmentIds: {},
        trackingMode: TrackingMode.time,
      );
      await repo.start(exerciseIds: [other, plank]);
      final link = (await repo.watchActive().first)!.entries.first.link;
      await repo.setTargets(link.id, sets: 1, reps: 16);
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          notificationsProvider.overrideWithValue(NotificationService()),
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const ActiveWorkoutScreen(),
        ),
      ),
    );
    await settle();
    expect(find.text('×16'), findsOneWidget);
    expect(find.text('Série 1 de 1'), findsOneWidget);

    // Concluir a série leva ao descanso, com a prévia do próximo exercício.
    await tester.tap(find.byIcon(Icons.check));
    await settle();
    expect(find.text('DESCANSO'), findsOneWidget);
    expect(find.text('PRÓXIMO 2/2'), findsOneWidget);
    expect(find.text('Prancha'), findsOneWidget);
    expect(find.text('+20s'), findsOneWidget);

    // Pular o descanso: o exercício por tempo já sai contando.
    await tester.tap(find.text('Pular'));
    await settle();
    expect(find.text('DESCANSO'), findsNothing);
    expect(find.byIcon(Icons.pause), findsOneWidget);

    // A folha de modo abre e troca para repetições.
    await tester.tap(find.text('Tempo'));
    await settle();
    await tester.tap(find.text('Modo Repetições'));
    await tester.tap(find.text('Confirmar'));
    await settle();
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
