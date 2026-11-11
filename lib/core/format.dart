import 'package:intl/intl.dart';

import 'tracking_mode.dart';

final _date = DateFormat('dd/MM/yyyy');
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');

String formatDate(DateTime d) => _date.format(d);
String formatDateTime(DateTime d) => _dateTime.format(d);

/// `1:05:09` ou `05:09`. Durações negativas viram zero.
String formatDuration(Duration d) {
  final s = d.isNegative ? 0 : d.inSeconds;
  String two(int n) => n.toString().padLeft(2, '0');
  final h = s ~/ 3600, m = s % 3600 ~/ 60;
  return h > 0 ? '$h:${two(m)}:${two(s % 60)}' : '${two(m)}:${two(s % 60)}';
}

/// Sem casas decimais desnecessárias: `20`, `22.5`.
String formatNumber(double n) =>
    n == n.roundToDouble() ? n.round().toString() : n.toStringAsFixed(1);

/// `3.3 kcal` abaixo de 10, `538 kcal` daí em diante.
String formatKcal(double kcal) =>
    '${kcal.toStringAsFixed(kcal < 10 ? 1 : 0)} kcal';

/// Meta de uma série: `×12` ou `00:30`, conforme o modo.
String formatTarget(
  TrackingMode mode, {
  required int reps,
  required int seconds,
}) => mode == TrackingMode.time
    ? formatDuration(Duration(seconds: seconds))
    : '×$reps';
