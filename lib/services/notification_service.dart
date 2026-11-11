import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Notificações locais do treino. Os timers em si são calculados a partir de
/// horários gravados no banco; estas notificações só existem para avisar com o
/// app em segundo plano. Toda falha (plataforma sem suporte, permissão negada)
/// é ignorada: o treino funciona sem notificações.
class NotificationService {
  static const _restId = 1;
  static const _workoutId = 2;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _exactAlarms = false;

  Future<void> init() async {
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
          linux: LinuxInitializationSettings(defaultActionName: 'Abrir'),
        ),
      );
      _ready = true;
    } catch (e) {
      debugPrint('Notificações indisponíveis: $e');
    }
  }

  /// Pede as permissões na primeira vez que um treino começa.
  Future<void> requestPermissions() async {
    if (!_ready) return;
    try {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
      _exactAlarms = await android?.requestExactAlarmsPermission() ?? false;
    } catch (e) {
      debugPrint('Permissão de notificação: $e');
    }
  }

  Future<void> scheduleRestEnd(DateTime endsAt) => _guard(
    () => _plugin.zonedSchedule(
      id: _restId,
      title: 'Descanso encerrado',
      body: 'Hora da próxima série.',
      scheduledDate: tz.TZDateTime.from(endsAt, tz.UTC),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'rest',
          'Fim do descanso',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: _exactAlarms
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    ),
  );

  Future<void> cancelRestEnd() => _guard(() => _plugin.cancel(id: _restId));

  /// Notificação fixa com o cronômetro global do treino (Android).
  Future<void> showWorkoutRunning(DateTime startedAt) => _guard(
    () => _plugin.show(
      id: _workoutId,
      title: 'Treino em andamento',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'workout',
          'Treino em andamento',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          onlyAlertOnce: true,
          usesChronometer: true,
          when: startedAt.millisecondsSinceEpoch,
        ),
      ),
    ),
  );

  Future<void> cancelWorkoutRunning() =>
      _guard(() => _plugin.cancel(id: _workoutId));

  Future<void> _guard(Future<void> Function() action) async {
    if (!_ready) return;
    try {
      await action();
    } catch (e) {
      debugPrint('Notificação falhou: $e');
    }
  }
}
