/// Grupos musculares usados em exercícios, histórico e planejador.
/// O `name` do enum é o valor gravado no banco e no JSON — não renomear.
enum MuscleGroup {
  peito('Peito', 10),
  costas('Costas', 10),
  ombros('Ombros', 8),
  biceps('Bíceps', 6),
  triceps('Tríceps', 6),
  quadriceps('Quadríceps', 10),
  posteriores('Posteriores', 8),
  gluteos('Glúteos', 8),
  panturrilhas('Panturrilhas', 6),
  abdomen('Abdômen', 6);

  const MuscleGroup(this.label, this.weeklyTargetSets);

  final String label;

  /// Meta de séries efetivas por semana — a referência de "equilíbrio".
  final int weeklyTargetSets;

  static MuscleGroup? tryParse(String value) {
    for (final g in values) {
      if (g.name == value) return g;
    }
    return null;
  }
}
