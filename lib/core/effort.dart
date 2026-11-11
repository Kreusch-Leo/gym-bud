/// Percepção de esforço informada ao concluir o treino. O `name` do enum é o valor
/// gravado no banco e no JSON — não renomear.
enum Effort {
  hard('Muito difícil'),
  right('Na medida'),
  easy('Muito fácil');

  const Effort(this.label);

  final String label;

  static Effort? tryParse(String? value) {
    for (final e in values) {
      if (e.name == value) return e;
    }
    return null;
  }
}
