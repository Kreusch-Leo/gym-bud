/// Como uma série é medida. O `name` do enum é o valor gravado no banco e no
/// JSON — não renomear.
enum TrackingMode {
  reps('Repetições', 'Faça um número definido de repetições.'),
  time('Tempo', 'Faça o exercício por um tempo definido.');

  const TrackingMode(this.label, this.description);

  final String label;
  final String description;

  static TrackingMode? tryParse(String? value) {
    for (final m in values) {
      if (m.name == value) return m;
    }
    return null;
  }
}
