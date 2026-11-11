import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/exercises/exercise_edit_screen.dart';
import 'features/exercises/exercise_list.dart';
import 'features/gyms/gyms_screen.dart';
import 'features/history/history_screen.dart';
import 'features/metrics/metrics_screen.dart';
import 'features/today/today_screen.dart';
import 'providers.dart';

class GymBudApp extends StatelessWidget {
  const GymBudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Bud',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C164E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0E0F11),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Ao voltar para o app, o tempo passou (fadiga) e o lugar pode ter mudado.
    if (state != AppLifecycleState.resumed) return;
    if (ref.read(locationProvider).source != LocationSource.manual) {
      ref.read(locationProvider.notifier).detect();
    }
    ref.invalidate(suggestionProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            const TodayScreen(),
            ExerciseList(
              onTap: (info) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ExerciseEditScreen(existing: info),
                ),
              ),
            ),
            const HistoryScreen(),
            const MetricsScreen(),
            const GymsScreen(),
          ],
        ),
      ),
      floatingActionButton: _tab == 1
          ? FloatingActionButton(
              tooltip: 'Novo exercício',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExerciseEditScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Hoje'),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight),
            label: 'Corpo',
          ),
          NavigationDestination(icon: Icon(Icons.place), label: 'Locais'),
        ],
      ),
    );
  }
}
