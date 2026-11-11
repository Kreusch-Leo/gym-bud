import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_bud/core/effort.dart';
import 'package:gym_bud/core/muscle_group.dart';
import 'package:gym_bud/data/database.dart';
import 'package:gym_bud/data/repositories.dart';
import 'package:gym_bud/features/workout/workout_overview_screen.dart';
import 'package:gym_bud/providers.dart';
import 'package:gym_bud/services/notification_service.dart';

/// Local fixo: o teste não tem GPS para detectar.
class _NoGps extends LocationController {
  @override
  LocationState build() => const LocationState(LocationSource.manual);
}

void main() {
  testWidgets('visão geral → execução → conclusão → histórico → início', (
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

    late int exerciseId;
    await tester.runAsync(() async {
      exerciseId = await CatalogRepository(db).saveExercise(
        name: 'Supino',
        primary: MuscleGroup.peito,
        secondary: [],
        equipmentIds: {},
      );
      await MetricsRepository(db).add(
        BodyMetricsCompanion.insert(
          date: DateTime(2026, 1, 1),
          weightKg: const Value(80),
          heightCm: const Value(200),
        ),
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dbProvider.overrideWithValue(db),
          notificationsProvider.overrideWithValue(NotificationService()),
          locationProvider.overrideWith(_NoGps.new),
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        WorkoutOverviewScreen(exerciseIds: [exerciseId]),
                  ),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await settle();

    // Plano ainda não iniciado: 3 séries × (12 reps × 3 s + 60 s de descanso).
    expect(find.text('≈ 5 min · 1 exercício'), findsOneWidget);
    expect(find.text('3 × ×12'), findsOneWidget);
    expect(find.text('Reiniciar'), findsNothing);

    await tester.tap(find.text('Iniciar'));
    await settle();
    expect(find.text('Série 1 de 3'), findsOneWidget);

    // Voltar à visão geral depois de uma série: reiniciar ou continuar.
    await tester.tap(find.byIcon(Icons.check));
    await settle();
    await tester.pageBack();
    await settle();
    expect(find.text('Reiniciar'), findsOneWidget);
    expect(find.text('Continuar · 33%'), findsOneWidget);
    expect(find.text('1/3 · ×12'), findsOneWidget);

    await tester.tap(find.text('Reiniciar'));
    await settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reiniciar').last);
    await settle();
    expect(find.text('Série 1 de 3'), findsOneWidget);

    // Última série do treino: vai para a conclusão.
    await tester.runAsync(() async {
      final link = (await repo.watchActive().first)!.entries.single.link;
      await repo.setTargets(link.id, sets: 1);
    });
    await settle();
    await tester.tap(find.byIcon(Icons.check));
    await settle();
    expect(find.text('Boa! Treino concluído!'), findsOneWidget);
    expect(find.text('Calorias (est.)'), findsOneWidget);
    // Em tela pequena o peso e a régua ficam abaixo da dobra.
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await settle();
    expect(find.text('IMC 20.0 · peso normal'), findsOneWidget);

    await tester.tap(find.text('Na medida'));
    await tester.enterText(find.widgetWithText(TextField, 'Peso (kg)'), '104');
    await settle();
    expect(find.text('IMC 26.0 · sobrepeso'), findsOneWidget);

    await tester.ensureVisible(find.text('Próximo'));
    await tester.tap(find.text('Próximo'));
    await settle();
    expect(find.text('Treino salvo'), findsOneWidget);
    expect(find.text('Resumo semanal'), findsOneWidget);
    await tester.runAsync(() async {
      final saved = (await repo.watchHistory().first).single;
      expect(saved.workout.effort, Effort.right);
      final metrics = await MetricsRepository(db).watchAll().first;
      expect(metrics.map((m) => m.weightKg), [80, 104]);
    });

    await tester.tap(find.text('Concluir'));
    await settle();
    expect(find.text('abrir'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
